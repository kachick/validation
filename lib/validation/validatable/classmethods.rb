# coding: us-ascii
# frozen_string_literal: true

module Validation
  module Validatable
    module ClassMethods
      # @param name [Symbol, String]
      # @param pattern [Proc, Method, #===]
      # @return [Symbol]
      def attr_reader_with_validation(name, pattern)
        define_method(name) do
          ivar = :"@#{name}"
          unless instance_variable_defined?(ivar)
            instance_variable_set(ivar, nil)
          end

          value = instance_variable_get(ivar)

          unless _valid?(pattern, value)
            raise InvalidReadingError,
                  "#{value.inspect} is deficient for #{name} in #{self.class}"
          end

          value
        end
      end

      # @param name [Symbol, String]
      # @param pattern [Proc, Method, #===]
      # @return [Symbol]
      def attr_writer_with_validation(name, pattern, &adjuster)
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

          if _valid?(pattern, value)
            instance_variable_set(:"@#{name}", value)
          else
            raise InvalidWritingError,
                  "#{value.inspect} is deficient for #{name} in #{self.class}"
          end
        end
      end

      # @param name [Symbol, String]
      # @param pattern [Proc, Method, #===]
      # @param [Boolean] reader_validation
      # @param [Boolean] writer_validation
      # @return [Array<Symbol>]
      def attr_accessor_with_validation(name, pattern, writer_validation: true, reader_validation: true, &adjuster)
        reader_name = (
          if reader_validation
            attr_reader_with_validation(name, pattern)
          else
            attr_reader(name)
          end
        )

        writer_name = (
          if writer_validation
            attr_writer_with_validation(name, pattern, &adjuster)
          else
            attr_writer(name)
          end
        )

        [reader_name, writer_name]
      end
    end
  end
end
