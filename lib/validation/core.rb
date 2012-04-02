# Copyright (C) 2011-2012  Kenichi Kamiya
# 
# @author Kenichi Kamiya
# @example overview
#   class Person
#     include Validation
#     attr_validator :name, String
module Validation

  class InvalidError < TypeError; end
  class InvalidReadingError < InvalidError; end
  class InvalidWritingError < InvalidError; end
  class UnmanagebleError < InvalidError; end
  InvalidAdjustingError = UnmanagebleError
  
  class << self
    private
    
    def included(mod)
      mod.module_eval do
        extend Condition
        extend Adjustment
        extend Validatable::Eigen
        include Validatable
      end
    end
  end

  module_function

  def conditionable?(object)
    Condition.__send__ __callee__, object
  end

  def adjustable?(object)
    Adjustment.__send__ __callee__, object
  end

end