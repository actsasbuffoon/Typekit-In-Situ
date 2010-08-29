require 'FSSM'
require 'json'
require 'sinatra/base'

desc "Autoupdate files."
task :watch do
  port = 4567
  run_monitor(port)
  start_fileserver(port).join
end

def run_monitor(port)
  monitor = Thread.new do
    FSSM.monitor(".", "**/*") do
      update do |base, name|
        unless name =~ /\.html$/ || name =~ /\.js$/ || name =~ /\.css$/
          js_files = process({:before_dir => "coffeescripts", :before_ext => "coffee",
                             :after_dir  => "javascripts",   :after_ext  => "js"}) {|args| `coffee --no-wrap -o #{args[:after_dir]} -c #{args[:before_name]}`}
        
          css_files = process({:before_dir => "sass", :before_ext => "sass",
                              :after_dir  => "css",   :after_ext  => "css"}) {|args| `sass #{args[:before_name]} #{args[:after_dir]}/#{args[:after_name]}`}
        
          html_files = process({:before_dir => "haml", :before_ext => "haml",
                               :after_dir  => "html",   :after_ext  => "html"}) {|args| `haml #{args[:before_name]} #{args[:after_dir]}/#{args[:after_name]}`}
        
          image_files = {}
          Dir.glob("images/*").each do |dir|
            temp = dir.split("/").last
            image_files[temp] = {}
            Dir.glob("#{dir}/*").each do |f|
              image_files[temp][f.split("/").last] = f.gsub(/^images\//, "")
            end
          end
        
          html_files.each_pair do |key, html|
            if image_files[key]
              image_files[key].each_pair do |filename, path|
                if html.include?(filename)
                  html_files[key] = html.gsub(filename, "http://localhost:#{port}/#{path}")
                end
              end
            end
          end
        
          css_files.each_pair do |key, css|
            if image_files[key]
              image_files[key].each_pair do |filename, path|
                if css_files[key].include?(filename)
                  css_files[key] = css.gsub(filename, "http://localhost:#{port}/#{path}")
                end
              end
            end
          end
        
          templates = {}
        
          html_files.keys.each do |k|
            templates[k] = <<-EOS
              <style type='text/css'>
                #{css_files[k]}
              </style>
              <script type='text/javascript'>
                #{js_files[k]}
              </script>
              #{html_files[k]}
            EOS
          end
          ifile = "templates = #{templates.to_json};\n"
          ifile += File.read("javascripts/application.js")
          File.open("javascripts/application.js", "w") {|f| f.write ifile}
          `cat javascripts/application.js | pbcopy`
          puts "Finished - #{Time.now}"
        end
      end
    end
  end
end

def process(args = {})
  ret = {}
  Dir.glob("#{args[:before_dir]}/*.#{args[:before_ext]}").each do |f|
    args[:before_name] = f
    args[:after_name] = f.split("/").last.gsub(args[:before_ext], args[:after_ext])
    yield args
    ret[args[:after_name].gsub(".#{args[:after_ext]}", "")] = File.read("#{args[:after_dir]}/#{args[:after_name]}")
  end
  ret
end

class TISFileServer < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/images'
end

def start_fileserver(port)
  fileserver = Thread.new do
    TISFileServer.run! :host => 'localhost', :port => (port)
  end
end