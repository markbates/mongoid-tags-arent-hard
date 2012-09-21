require 'delegate'
require 'mongoid'
require "mongoid/tags_arent_hard/version"
require "mongoid/tags_arent_hard/configuration"
require "mongoid/tags_arent_hard/tags_arent_hard"
require "mongoid/tags_arent_hard/tags"

module Mongoid
  module TagsArentHard

    def self.config(&block)
      @config ||= Configuration.new
      yield @config if block_given?
      return @config
    end
    
  end
end
