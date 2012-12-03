require "pathname"
require "fileutils"

module HTMLPackage
  class Loader

    def initialize(package, out_dir)
      @package = package
      @out_dir = Pathname.new(out_dir).expand_path
      FileUtils.mkdir_p(@out_dir)
    end

    def load_file(uri, out_dir)
      return if uri == nil
      puts "loading: #{uri.blue}"
      Thread.new do
        begin
          content = open(uri).read            
          outfile = out_dir + Pathname.new(uri).basename.to_s.gsub(/-([\d].?){3}.*\.js$/, ".js")

          begin
            File.open(outfile, "w") { |file| file.write content }            
          rescue Exception => e
            puts "failed: File.write #{outfile.to_s.red}"
            puts "        #{e.class.name.bold} #{e.message.red.bold}"
            puts
          end
        rescue OpenURI::HTTPError => e
          puts "failed: GET #{uri.red}"
          puts "        #{e.class.name.bold} #{e.message.red.bold}"
          puts
        end

      end
    end

    def load(options={})
      threads = []

      threads += @package.all_files.map do |uri|
        load_file(uri, @out_dir)
      end

      threads.map{|thread| thread and thread.join }
    end
  end
end