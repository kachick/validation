$VERBOSE = true

require_relative '../lib/validation'

class MyClass
  include Validation
  
  p ancestors
  p respond_to?(:attr_validator, false)
  p respond_to?(:attr_validator, true)
  
  attr_validator :name, String
  attr_validator :id, OR(nil, AND(Integer, 1..100))
end

my = MyClass.new
#~ my.name = 8  #=> error
my.name = 'Ken'
#~ my.name = nil  #=> error
p my

my.id = nil
#~ my.id = 'fail' #=> error
#~ my.id = 101 #=> error
#~ my.id = 99.9 #=> error
my.id = 100
p my