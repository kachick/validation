module Validation

  module_function

  def conditionable?(object)
    Condition.__send__ __callee__, object
  end

  def adjustable?(object)
    Adjustment.__send__ __callee__, object
  end

end
