desc "build the gem"
task :gem do
  system "rm *.gem"
  system "gem build html_package.gemspec"
end

desc "install the gem"
task :install => :gem do
  system "gem install html_package*.gem"
end