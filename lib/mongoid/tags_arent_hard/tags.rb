module Mongoid
  module TagsArentHard
    class Tags

      attr_accessor :tag_list
      attr_accessor :options
      delegate :<<, :join, :map, :each, :inspect, :==, :===, :eql?, :__bson_dump__, to: :tag_list

      def initialize(*tag_list, options)
        self.options = {separator: Mongoid::TagsArentHard.config.separator}.merge(options)
        self.tag_list = self.normalize(*tag_list)
      end

      def normalize(*tag_list)
        tag_list.flatten.map {|s| s.split(self.options[:separator]).map {|x| x.strip}}.flatten
      end

      def to_s
        self.join(self.options[:separator])
      end

      def to_str
        self.to_s
      end

    end
  end
end