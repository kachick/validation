# coding: us-ascii
# frozen_string_literal: true

require_relative 'validatable/classmethods'

module Validation
  # A way of defining accessor with flexible validations.
  # @example define accessor with validations
  #   class Person
  #     include Validation
  #     attr_accessor_with_validation :name, AND(String, /\A\w+(?: \w+)*\z/), &:strip
  #     attr_accessor_with_validation :birthday, Time
  #   end
  module Validatable
    private

    # @param [Proc, Method, #===] pattern
    # @param [Object] value
    def _valid?(pattern, value)
      !!(
        case pattern
        when Proc
          instance_exec(value, &pattern)
        when Method
          pattern.call(value)
        else
          pattern === value
        end
      )
    end
  end
end
