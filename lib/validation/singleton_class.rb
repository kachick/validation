# coding: us-ascii

module Validation
  
  class << self
    
    private
    
    def included(mod)
      mod.module_eval do
        
        extend Condition
        extend Adjustment
        extend Validatable::ClassMethods
        include Validatable
        
      end
    end

  end

end