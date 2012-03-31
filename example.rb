$VERBOSE = true

require_relative 'lib/validation'

class MyClass
  include Validation
  
  p respond_to?(:attr_validator)
end