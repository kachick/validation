# coding: us-ascii

$VERBOSE = true

require_relative '../lib/validation'

class Person
  include Validation
  
  attr_validator :name, String
  attr_validator :id, OR(nil, AND(Integer, 1..100))
end

person = Person.new
#~ person.name = 8  #=> error
person.name = 'Ken'
#~ person.name = nil  #=> error
p person

person.id = nil
#~ person.id = 'fail' #=> error
#~ person.id = 101 #=> error
#~ person.id = 99.9 #=> error
person.id = 100
p person