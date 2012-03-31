# Copyright (C) 2011-2012  Kenichi Kamiya
# 
# @author Kenichi Kamiya
# @example overview
#   class Person
#     include Validation
#     attr_validator :name, String
module Validation

  class InvalidError < TypeError; end

  class << self
    private
    
    def included(mod)
      mod.module_eval do
        extend ::Validation::Condition::Builders
        extend ::Validation::Condition::Patterns
        extend ::Validation::Adjustment::Builders
        extend ::Validation::Adjustment::Patterns
        extend ::Validation::Validatable::Eigen
        include ::Validation::Validatable
      end
    end
  end

end