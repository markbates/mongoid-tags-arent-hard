require 'bundler'  
Bundler::GemHelper.install_tasks

desc "Run tests"
task :default => [:ruby]

task :ruby do
  system "bundle exec rspec"
end