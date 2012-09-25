module Mongoid
  module TagsArentHard
    class Tags

      attr_accessor :tag_list
      attr_accessor :options
      delegate :join, :map, :each, :inspect, :==, :===, :eql?, :__bson_dump__, :delete, :&, :to_ary, :to_json, :as_json, to: :tag_list

      def initialize(*tag_list, options)
        self.options = {separator: Mongoid::TagsArentHard.config.separator}.merge(options)
        self.tag_list = []
        self.<<(*tag_list)
      end

      def normalize(*tag_list)
        x = tag_list.flatten.map {|s| s.split(self.options[:separator]).map {|x| x.strip}}.flatten
        return x
      end

      def <<(*tag_list)
        self.tag_list << self.normalize(*tag_list)
        self.tag_list.flatten!
        self.tag_list.uniq!
        if self.options[:owner]
          self.options[:owner].send("#{self.options[:_name]}_will_change!")
        end
        return self
      end

      def +(*tag_list)
        self.<<(*tag_list)
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