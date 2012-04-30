$VERBSOE = true

require 'validation'

module Validation
  extend Condition
  include Condition
  extend Validatable

  module_function

  # @parameter [Hash] options
  # @parameter [Hash, #each_pair] requirements
  #   must: Always need
  #   let:  need or not-need
  #   {must: [:must1, :mustN], let: [:let1, :letN]}
  # @return options
  # @example
  #   class MyClass
  #     def func(options)
  #       Validation.validate_keys options, must: [:a, :c], let: [:b]
  #     end
  #   end
  #   
  #   obj = MyClass.new
  #   obj.func a: 1, b: 10, c: 100           #=> pass
  #   obj.func a: 1, c: 100                  #=> pass
  #   obj.func a: 1, b: 10                   #=> ArgumentError
  #   obj.func a: 1, b: 10, c: 100, d: 1000  #=> ArgumentError
  #   
  def validate_keys(options, requirements)
    raise TypeError unless _valid? CAN(:each_pair), options
    raise TypeError unless _valid? CAN(:each_pair), requirements
    raise TypeError unless _valid? GENERICS(CAN(:eql?)), requirements[:must]
    raise ArgumentError unless requirements.keys.all?{|key|[:must, :let].include? key}
    raise ArgumentError unless (requirements[:must] & requirements[:let]).empty?

    shortage = requirements[:must] - options.keys
    excess   = options.keys - (requirements[:must] + requirements[:let])
    
    unless [*shortage, *excess].empty?
      raise ArgumentError,
      "Invalid named in key-value options: Shortage => #{shortage}, Excess => #{excess}"
    end

    options
  end
end


class MyClass 
  def func(options)
    Validation.validate_keys options, must: [:a, :c], let: [:b]
  end
end

obj = MyClass.new
obj.func a: 1, b: 10, c: 100           #=> pass
obj.func a: 1, c: 100                  #=> pass
obj.func a: 1, b: 10                   #=> ArgumentError
obj.func a: 1, b: 10, c: 100, d: 1000  #=> ArgumentError
