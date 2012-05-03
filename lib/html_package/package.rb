require "nokogiri"

module HTMLPackage
  class Package
    JAVASCRIPT = "text/javascript"
    PACKAGE = "text/package+html"
    SPADE = "text/spade+javascript"

    PACKAGES = "[type='#{PACKAGE}']"
    SCRIPTS =  "[type='#{JAVASCRIPT}']"
    SPADES =  "[type='#{SPADE}']"

    SELF = "[rel='self']"
    DEPENDENCY = "[rel='dependency']"
    DEVELOPMENT_DEPENDENCY = "[rel$='dependency']"

    def self.open(uri, resource_type=SPADES, development = false)
      puts "opening package: #{uri.green}"
      new Nokogiri::HTML(Kernel.open uri), resource_type, development
    rescue OpenURI::HTTPError => e
      puts "failed: GET #{uri.red}"
      puts "        #{e.class.name.bold} #{e.message.red.bold}"
      puts
    end

    def initialize(document, resource_type, development)
      @document = document
      @resource_type = resource_type
      @development = development
      if @development
        @dependency_type = DEVELOPMENT_DEPENDENCY
      else
        @dependency_type = DEPENDENCY
      end
    end

    def own_files
      links(SELF, @resource_type).map{|link| link[:href]}
    end

    def dependency_packages
      @dependency_packages ||= begin
        links(@dependency_type, PACKAGES).map do |package_link|
          href = package_link[:href]
          puts "dependency: #{href.blue}"
          HTMLPackage::Package.open(href, @resource_type, @dependency_type)
        end      
      end.compact
    end

    def dependency_files
      links = []
      links += direct_links = links(@dependency_type, @resource_type).map{|link| link[:href]} 
      
      dependency_packages.each do |package|
        links += package.all_files
      end

      links
    end

    def all_files
      @all_files ||= ( own_files + dependency_files ).uniq
    end

    def links(*properties)
      find ["link"].concat(properties).join
    end

    def find(selector)
      @document.css(selector)
    end
  end
end
