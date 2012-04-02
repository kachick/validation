# Copyright (C) 2011-2012  Kenichi Kamiya

module Validation

  # A way of defining accessor with flexible validations.
  # @example define accessor with validations
  #   class Person
  #     include Validation
  #     attr_validator :name, AND(String, /\A\w+(?: \w+)*\z/), &:strip
  #     attr_validator :birthday, Time
  module Validatable 
    module Eigen
      ACCESSOR_OPTIONS = [:reader_validation, :writer_validation].freeze
      METHOD_OPTIONS = [:arg, :args, :ret, :doc].freeze
      
      def attr_reader_with_validation(name, condition)
        define_method name do
          value = instance_variable_get :"@#{name}"
        
          unless _valid? condition, value
            raise InvalidReadingError,
                  "#{value.inspect} is deficient for #{name} in #{self.class}"
          end

          value
        end
        
        nil
      end
    
      def attr_writer_with_validation(name, condition=ANYTHING?, &adjuster)        
        if block_given?
          adjustment = true
        end
        
        define_method :"#{name}=" do |value|
          raise "can't modify frozen #{self.class}" if frozen?

          if adjustment
            begin
              value = instance_exec value, &adjuster
            rescue Exception
              raise InvalidAdjustingError, $!
            end
          end
          
          if _valid? condition, value
            instance_variable_set :"@#{name}", value
          else
            raise InvalidWritingError,
              "#{value.inspect} is deficient for #{name} in #{self.class}"
          end
        end
        
        nil
      end
  
      def attr_accessor_with_validation(name, condition=ANYTHING?, options={writer_validation: true}, &adjuster)
        unless (options.keys - ACCESSOR_OPTIONS).empty?
          raise ArgumentError, 'invalid option parameter is'
        end
        
        if options[:reader_validation]
          attr_reader_with_validation name, condition
        else
          attr_reader name
        end
        
        if options[:writer_validation]
          attr_writer_with_validation name, condition, &adjuster
        else
          attr_writer name
        end
      end

      alias_method :attr_validator, :attr_accessor_with_validation
      private(
        :attr_reader_with_validation,
        :attr_writer_with_validation,
        :attr_accessor_with_validation,
        :attr_validator
      )
    end

    private

    # @param [Proc, Method, #===] condition
    # @param [Object] value
    def _valid?(condition, value)
      case condition
      when ::Validation::Condition::ANYTHING
        true
      when Proc
        instance_exec value, &condition
      when Method
        condition.call value
      else
        condition === value
      end ? true : false
    end
  end

end
