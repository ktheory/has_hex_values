# HasHexValues
#require 'activerecord/base'
module ActiveRecord #:nodoc:
  module HasHexValues
    def self.included(base)
      base.extend(ClassMethods)  
    end
  
    # declare the class level helper methods which
    # will load the relevant instance methods
    # defined below when invoked
    module ClassMethods
      def has_hex_values(*attrs)
        attrs.each do |attr|
          # Define reader method
          define_method attr do
            raw_attr = read_attribute(attr)
            raw_attr.nil? ? nil : raw_attr.unpack('H*')[0]
          end

          # Define setter method
          define_method "#{attr}=" do |new_value|
            write_attribute(attr, new_value.nil? ? nil : [new_value].pack('H*'))
          end
        end

        extend ActiveRecord::HasHexValues::SingletonMethods
        include ActiveRecord::HasHexValues::InstanceMethods
      end
    end
    
    module SingletonMethods; end
    module InstanceMethods; end
  end
end
ActiveRecord::Base.send(:include, ActiveRecord::HasHexValues)
