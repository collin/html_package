require "pathname"

module HTMLPackage
  class Loader

    def initialize(package, out_dir)
      @package = package
      @out_dir = Pathname.new(out_dir).expand_path
    end

    def load
      threads = @package.all_files.map do |uri|
        puts "loading: #{uri.blue}"
        Thread.new do
          begin
            content = open(uri).read            
            outfile = @out_dir + Pathname.new(uri).basename
  
            begin
              File.open(outfile, "r") { |file| file.write content }            
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
      threads.map(&:join)
    end
  end
end