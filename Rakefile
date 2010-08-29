require 'FSSM'
require 'json'

desc "Autoupdate files."
task :watch do
  FSSM.monitor(".", "**/*") do
    update do |base, name|
      unless name =~ /\.html$/ || name =~ /application\.js$/ || name =~ /\.css$/
        `coffee --no-wrap -o javascripts -c coffeescripts/application.coffee`
        css_files = {}
        html_files = {}
        templates = {}
        Dir.glob("sass/*.sass").each do |f|
          css_name = f.split("/").last.gsub(".sass", ".css")
          `sass #{f} css/#{css_name}`
          css_files[css_name.gsub(".css", "")] = File.read("css/#{css_name}")
        end
        Dir.glob("haml/*.haml").each do |f|
          html_name = f.split("/").last.gsub(".haml", ".html")
          `haml #{f} html/#{html_name}`
          html_files[html_name.gsub(".html", "")] = File.read("html/#{html_name}")
        end
        html_files.keys.each do |k|
          templates[k] = "<style type='text/css'>\n#{css_files[k]}\n</style>\n#{html_files[k]}"
        end
        ifile = "templates = #{templates.to_json}\n;\n"
        ifile += File.read("javascripts/application.js")
        File.open("javascripts/application.js", "w") {|f| f.write ifile}
        `cat javascripts/application.js | pbcopy`
        puts "Finished - #{Time.now}"
      end
    end
  end
end