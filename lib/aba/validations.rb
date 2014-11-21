class Aba
  module Validations
    def self.included(base)
      base.send :extend, ClassMethods
    end

    def valid?
      self.errors = []

      self.class.validate_presence_attrs.each do |attribute|
        value = send(attribute)
        self.errors << "#{attribute} is empty" if value.nil? || value.to_s.empty?
      end

      self.class.validates_bsb.each do |attribute|
        value = send(attribute)
        self.errors << "#{attribute} must be of a correct bsb format (XXX-XXX)" if value =~ /^\d{3}-\d{3}$/
      end

      return self.errors.empty?
    end
   
    module ClassMethods
      attr_reader :validate_presence_attrs, :validate_bsb_attrs, :errors

      def validates_presence_of(*attributes)
        @validate_presence_attrs = attributes
      end

      def validates_bsb(*attributes)
        @validate_bsb_attrs = attributes
      end
    end
  end
end