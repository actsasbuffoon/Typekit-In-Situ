require 'fileutils'
require 'FSSM'
require 'json'
require 'sinatra/base'

desc "Autoupdate files."
task :watch do
  port = 4567
  run_monitor port
  start_fileserver(port).join
end

def run_monitor(port)
  tis = TIS.new(port)
  Thread.new do
    FSSM.monitor("templates", "**/*") do
      update do |base, name|
        temp_message "Updating..."
        tis.clear_output
        tis.preprocess
        tis.prepare_assets
        tis.map_assets
        tis.substitute_assets
        tis.create_json
        tis.compile_main
        temp_message "Finished"
      end
    end
  end
end

class TISFileServer < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/output/public'
end

def start_fileserver(port)
  Thread.new do
    TISFileServer.run! :host => 'localhost', :port => (port)
  end
end

def temp_message(mess)
  print "#{mess}#{" " * 10}\r"
  $stdout.flush
end

class TIS
  
  def initialize(port)
    @port = port
  end
  
  # Set ourselves up with a clean output directory.
  def clear_output
    FileUtils.remove_dir "output" if File.exist? "output"
    FileUtils.mkdir "output"
  end

  # Compile HAML, SASS, and Coffeescript templates.
  def preprocess
    Dir.glob("templates/*").each do |template_dir|
      dir_name = File.basename template_dir
      FileUtils.mkdir "output/#{dir_name}"
      Dir.glob("#{template_dir}/*").each do |file|
        if file =~ /\.haml$/
          `haml #{file} output/#{dir_name}/#{File.basename(file).sub(/\.haml$/, ".html")}`
        elsif file =~ /\.sass$/
          `sass #{file} output/#{dir_name}/#{File.basename(file).sub(/\.sass$/, ".css")}`
        elsif file =~ /\.coffee$/
          `coffee -o output/#{dir_name} --no-wrap #{file}`
        else
          FileUtils.cp_r file, "output/#{dir_name}"
        end
      end
    end
  end
  
  # Copy the public assets to the public directory for the
  # fileserver.
  def prepare_assets
    Dir.glob("output/*").each do |template_dir|
      dir_name = File.basename template_dir
      FileUtils.mkdir_p "output/public/#{dir_name}"
      Dir.glob("#{template_dir}/public").each do |pub_dir|
        FileUtils.cp_r Dir.glob("#{template_dir}/public/*"), "output/public/#{dir_name}"
      end
    end
  end

  # Get all the public assets and their server locations
  def map_assets
    ret = {}
    Dir.glob("output/public/*").each do |asset_dir|
      dir_name = File.basename asset_dir
      ret[dir_name] = {}
      Dir.glob("#{asset_dir}/*").each do |filepath|
        filename = File.basename filepath
        ret[dir_name][filename] = "http://localhost:#{@port}/#{dir_name}/#{filename}"
      end
    end
    @public_assets = ret
  end

  # Replace asset references with the server location.
  # For example, "<img src='foo.bar'/>" might become
  # "<img src='http://localhost:4567/my_awesome_template/foo.bar'/>"
  # It should work in HTML, CSS, and JS.
  def substitute_assets
    Dir.glob("output/*").each do |template_dir|
      dir_name = File.basename template_dir
      Dir.glob("#{template_dir}/*.*") do |file|
        content = File.read file
        @public_assets[dir_name].each_pair do |assetname, assetpath|
          content.gsub! assetname, assetpath
        end
        File.open(file, "w") {|f| f.write content}
      end
    end
  end
  
  # Combine all the HTML, CSS, and JS files, and return JSON.
  def create_json
    templates = {}
    Dir.glob("output/*").each do |template_dir|
      dir_name = File.basename template_dir
      next if dir_name == "public"
      data = []
      Dir.glob("#{template_dir}/*.*") do |file|
        data << "<script type='text/javascript'>#{File.read file}</script>" if file =~ /\.js$/
        data << "<style type='text/css'>#{File.read file}</style>" if file =~ /\.css$/
        data << File.read(file) if file =~ /\.html$/
      end
      templates[dir_name] = data.join("\n")
    end
    @templates = templates.to_json
  end
  
  # Wrap everything up can copy it to the clipboard.
  def compile_main
    `coffee --no-wrap -o output -c application.coffee`
    content = File.read "output/application.js"
    File.open("output/application.js", "w") {|f| f.write "templates = #{@templates};\n#{content}"}
    `cat output/application.js | pbcopy`
  end
end