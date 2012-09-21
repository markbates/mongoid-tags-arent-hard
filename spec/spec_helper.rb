require 'bundler/setup'

require 'mongoid-tags-arent-hard' # and any other gems you need

require 'database_cleaner'

Mongoid.load!(File.join(File.dirname(__FILE__), "config.yml"), :test)
# require File.join(File.dirname(__FILE__), "support", "models")

DatabaseCleaner[:mongoid].strategy = :truncation

RSpec.configure do |config|

  config.before(:each) do
    DatabaseCleaner.clean
    Mongoid::TagsArentHard.config.separator = ","
  end

  config.after(:each) do
    Mongoid::TagsArentHard.config.separator = ","
  end

end