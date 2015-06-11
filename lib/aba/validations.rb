class Aba
  require 'pry'
  module Validations
    attr_accessor :errors

    def self.included(base)
      base.instance_eval do
        @_validations = {}
      end

      base.send :extend, ClassMethods
    end

    # Run all validations
    def valid?
      self.errors = []

      self.class.instance_variable_get(:@_validations).each do |attribute, validations|
        value = send(attribute)

        validations.each do |type, param|
          case type
          when :presence
            self.errors << "#{attribute} is empty" if value.nil? || value.to_s.empty?
          when :bsb
            unless((param && value.nil?) || value =~ /^\d{3}-\d{3}$/)
              self.errors << "#{attribute} format is incorrect"
            end
          when :max_length
            self.errors << "#{attribute} length must not exceed #{param} characters" if value.to_s.length > param
          when :length
            self.errors << "#{attribute} length must be exactly #{param} characters" if value.to_s.length != param
          when :integer
            self.errors << "#{attribute} must be an integer" unless value.to_s =~ /\A[+-]?\d+\Z/
          end
        end
      end

      self.errors.empty?
    end
   
    module ClassMethods
      def validates_presence_of(*attributes)
        attributes.each do |a| 
          add_validation_attribute(a, :presence)
        end
      end

      def validates_bsb(attribute, options = {})
        options[:allow_blank] ||= false
        add_validation_attribute(attribute, :bsb, options[:allow_blank])
      end

      def validates_max_length(attribute, length)
        add_validation_attribute(attribute, :max_length, length)
      end

      def validates_length(attribute, length)
        add_validation_attribute(attribute, :length, length)
      end

      def validates_integer(attribute)
        add_validation_attribute(attribute, :integer)
      end

      private

      def add_validation_attribute(attribute, type, param = true)
        @_validations[attribute] = {} unless @_validations[attribute]
        @_validations[attribute][type] = param
      end
    end
  end
end
