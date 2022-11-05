class Sniphub
  module Validators
    class Validator
      attr_reader :errors

      class << self
        def validate(params={})
          new(params.dup).tap do |validator|
            validator.validate_required_attributes
            validator.validate
          end
        end

        def required(option = nil)
          @required ||= []

          return @required if option.nil?

          class_eval do
            attr_accessor option.to_sym
          end

          @required << option.to_sym

          @required
        end

        def optional(option = nil, default: nil)
          @optional ||= {}

          return @optional if option.nil?

          class_eval do
            attr_accessor option.to_sym
          end

          @optional[option.to_sym] = default

          @optional
        end
      end

      def initialize(params={})
        @errors = []

        self.class.optional.each do |key, value|
          public_send("#{key}=", value)
        end

        params.each do |key, value|
          public_send("#{key.to_sym}=", value)
        end
      end

      def validate_required_attributes
        self.class.required.each do |attr|
          errors.push({ attr.to_s => "is required" }) if self.send(attr.to_sym).nil? || self.send(attr.to_sym)&.empty?
        end
      end

      def validate
      end

      def success?
        @errors.empty?
      end

      def to_h
        (self.class.required + self.class.optional.keys).each_with_object({}) do |key, hash|
          hash.merge!(key => public_send(key))
        end.reject { |k,v| v.nil? }.to_h
      end
    end
  end
end
