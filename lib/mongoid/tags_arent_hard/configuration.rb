module Mongoid
  module TagsArentHard
    class Configuration
      attr_accessor :separator

      def initialize
        self.separator = ","
      end

    end
  end
end