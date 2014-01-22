source 'https://rubygems.org'

# Specify your gem's dependencies in mongoid_delorean.gemspec
gemspec

case version = ENV['MONGOID_VERSION'] || "~> 3.1"
when /4/
  gem "mongoid", :github => 'mongoid/mongoid'
when /3/
  gem "mongoid", "~> 3.1"
else
  gem "mongoid", version
end