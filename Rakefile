require 'FSSM'
require 'json'

desc "Autoupdate files."
task :watch do
  FSSM.monitor(".", "**/*") do
    update do |base, name|
      unless name =~ /\.html$/ || name =~ /\.js$/ || name =~ /\.css$/
        js_files = process({:before_dir => "coffeescripts", :before_ext => "coffee",
                           :after_dir  => "javascripts",   :after_ext  => "js"}) {|args| `coffee --no-wrap -o #{args[:after_dir]} -c #{args[:before_name]}`}
        
        css_files = process({:before_dir => "sass", :before_ext => "sass",
                            :after_dir  => "css",   :after_ext  => "css"}) {|args| `sass #{args[:before_name]} #{args[:after_dir]}/#{args[:after_name]}`}
        
        html_files = process({:before_dir => "haml", :before_ext => "haml",
                             :after_dir  => "html",   :after_ext  => "html"}) {|args| `haml #{args[:before_name]} #{args[:after_dir]}/#{args[:after_name]}`}

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