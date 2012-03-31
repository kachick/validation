# Copyright (C) 2012  Kenichi Kamiya
# 
# Code base from Striuct
#   http://rubygems.org/gems/striuct

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
        extend ::Validation::Adjuster::Builders
        extend ::Validation::Adjuster::Patterns
        extend ::Validation::Validatable::Eigen
        include ::Validation::Validatable
      end
    end
  end

end