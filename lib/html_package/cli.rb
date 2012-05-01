require "thor"
require "html_package"
module HTMLPackage
  class CLI < Thor
    map "-i" => :install

    desc "install", "installs a package"
    method_option "file", type: "string", required: true, banner: "(path or url to package file)"
    method_option "out", type: "string", required: true, banner: "(path to dir to install to)"
    method_option "dev", type: "boolean", banner: "Install development dependencies?"
    def install
      package = HTMLPackage::Package.open options[:file], nil, options[:dev]
      HTMLPackage::Loader.new(package, options[:out]).load
    end
  end
end