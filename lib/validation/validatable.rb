# Copyright (C) 2011-2012  Kenichi Kamiya

module Validation

  module Validatable
    module Eigen
      def attr_writer_with_validation(var, validator, options, &adjuster)
        options = DEFAULT_OPTIONS.merge options
        nil
      end

      def attr_accssor_with_validation(var, validator, options, &adjuster)
        attr_reader :var
        attr_writer_with_validation var, validator, options, &adjuster
        nil
      end

      alias_method :attr_validator, :attr_accessor_with_validation
    end

    # @param [Proc, Method, #===] condition
    # @param [Object] value
    def _valid?(condition, value)
      case condition
      when ::Validation::Condition::Patterns::ANYTHING
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

=begin
  # A way of defining accessor with flexible validations.
  # @example define accessor with validations
  #   class Person
  #     extend Validation::Validatable
  #     attr_validator :name, AND(String, /\A\w+(?: \w+)*\z/), &:strip
  #     attr_validator :birthday, Time
  module Validatable
    class InvalidReadingError < ConditionError; end
    class InvalidWritingError < ConditionError; end
    class InvalidProcedureError < ConditionError; end

    VALID_OPTIONS = [
                     :inference,
                     :reader_validation,
                     :getter_validation,
                     :writer_validation,
                     :setter_validation
                    ].freeze

    DEFAULT_OPTIONS = {
      setter_validation: true
    }.freeze

    method :symbolize, arg: String, ret: Symbol, doc: 'a string to a symbol' do |arg|
      arg.to_sym
    end
  end
=end