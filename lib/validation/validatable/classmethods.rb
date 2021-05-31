# coding: us-ascii
# frozen_string_literal: true

module Validation
  module Validatable
    module ClassMethods
      ACCESSOR_OPTIONS = [:reader_validation, :writer_validation].freeze

      private

      # @param name [Symbol, String]
      # @param condition [Proc, Method, #===]
      def attr_reader_with_validation(name, condition)
        define_method(name) do
          value = instance_variable_get(:"@#{name}")

          unless _valid?(condition, value)
            raise InvalidReadingError,
                  "#{value.inspect} is deficient for #{name} in #{self.class}"
          end

          value
        end

        nil
      end

      # @param name [Symbol, String]
      # @param condition [Proc, Method, #===]
      def attr_writer_with_validation(name, condition, &adjuster)
        if adjuster
          adjustment = true
        end

        define_method(:"#{name}=") do |value|
          raise "can't modify frozen #{self.class}" if frozen?

          if adjustment
            begin
              value = instance_exec(value, &adjuster)
            rescue Exception => err
              raise InvalidAdjustingError, err
            end
          end

          if _valid?(condition, value)
            instance_variable_set(:"@#{name}", value)
          else
            raise InvalidWritingError,
                  "#{value.inspect} is deficient for #{name} in #{self.class}"
          end
        end

        nil
      end

      # @param name [Symbol, String]
      # @param condition [Proc, Method, #===]
      # @param [Boolean] reader_validation
      # @param [Boolean] writer_validation
      def attr_accessor_with_validation(name, condition, writer_validation: true, reader_validation: true, &adjuster)
        if reader_validation
          attr_reader_with_validation(name, condition)
        else
          attr_reader(name)
        end

        if writer_validation
          attr_writer_with_validation(name, condition, &adjuster)
        else
          attr_writer(name)
        end
      end
    end
  end
end
