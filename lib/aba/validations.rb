class Aba
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
            self.errors << "#{attribute} format is incorrect" unless value =~ /^\d{3}-\d{3}$/
          when :max_length
            self.errors << "#{attribute} length must not exceed #{param} characters" if value.to_s.length > param
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

      def validates_bsb(*attributes)
        attributes.each do |a| 
          add_validation_attribute(a, :bsb)
        end
      end

      def validates_max_length(attribute, length)
        add_validation_attribute(attribute, :max_length, length)
      end

      private

      def add_validation_attribute(attribute, type, param = true)
        @_validations[attribute] = {} unless @_validations[attribute]
        @_validations[attribute][type] = param
      end
    end
  end
end