module Mongoid
  module TagsArentHard
    
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      
      def taggable_with(name, options = {})
        options = {separator: Mongoid::TagsArentHard.config.separator, _name: name}.merge(options)
        self.field(name, type: Array, default: [])
        self.class_eval do
          define_method(name) do
            val = super()
            unless val.is_a?(Mongoid::TagsArentHard::Tags)
              options.merge!(owner: self)
              val = Mongoid::TagsArentHard::Tags.new(val, options)
              self.send("#{name}=", val)
            end
            return val
          end
          define_method("#{name}=") do |val|
            unless val.is_a?(Mongoid::TagsArentHard::Tags)
              options.merge!(owner: self)
              val = Mongoid::TagsArentHard::Tags.new(val, options)
            end
            super(val)
          end

        end
        self.class.send(:define_method, "with_#{name}") do |*val|
          self.send("with_any_#{name}", *val)
        end

        self.class.send(:define_method, "with_any_#{name}") do |*val|
          any_in(name => Mongoid::TagsArentHard::Tags.new(*val, {}).tag_list)
        end

        self.class.send(:define_method, "with_all_#{name}") do |*val|
          all_in(name => Mongoid::TagsArentHard::Tags.new(*val, {}).tag_list)
        end
      end

    end

  end
end