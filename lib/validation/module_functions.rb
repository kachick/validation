# coding: us-ascii
# frozen_string_literal: true

module Validation
  module_function

  def adjustable?(object)
    Adjustment.__send__(__callee__, object)
  end
end
