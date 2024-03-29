lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "html_package"
  s.version     = "0.0.7"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Collin Miller"]
  s.email       = ["collintmiller@gmail.com"]
  s.homepage    = "http://github.com/collintmiller/html_package"
  s.summary     = "A package loader that reads html files."
  s.description = "Uses a special text/package+html content type to load packages of javascript files."
 
  s.required_rubygems_version = ">= 1.3.6"
  s.files        = Dir.glob("{bin,lib}/**/*") #+ %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.executables  = ['hip']
  s.require_path = 'lib'

  s.add_dependency "colored", ">= 1.2"
  s.add_dependency "thor", ">= 0.14"
  s.add_dependency "nokogiri", "~> 1.5.2"
end