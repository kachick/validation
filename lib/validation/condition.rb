# coding: us-ascii

module Validation

  module Condition

    module_function

    # @group Support Building Conditions
    
    # true if object is sufficient for condition.
    # @param [Object] object
    def conditionable?(object)
      case object
      when Proc, Method
        object.arity == 1
      else
        object.respond_to? :===
      end
    end
  
    # Condition Builders
    # A innner method for some condition builders.
    # For build conditions AND, NAND, OR, NOR, XOR, XNOR.
    # @param delegated [Symbol]
    # @return [lambda] 
    def _logical_operator(delegated, *conditions)
      unless conditions.all?{|c|conditionable? c}
        raise TypeError, 'wrong object for condition'
      end
      
      ->v{
        conditions.__send__(delegated) {|condition|
          _valid? condition, v
        }
      }
    end
    
    class << self
      private :_logical_operator
    end

    # A condition builder.
    # @param cond1 [Proc, Method, #===]
    # @param cond2 [Proc, Method, #===]
    # @param conds [Proc, Method, #===]
    # @return [lambda]
    #   this lambda return true if match all conditions
    def AND(cond1, cond2, *conds)
      _logical_operator :all?, cond1, cond2, *conds
    end
  
    # A condition builder.
    # @param cond1 [Proc, Method, #===]
    # @param cond2 [Proc, Method, #===]
    # @param conds [Proc, Method, #===]
    # @return [lambda] 
    def NAND(cond1, cond2, *conds)
      NOT AND(cond1, cond2, *conds)
    end

    # A condition builder.
    # @param cond1 [Proc, Method, #===]
    # @param cond2 [Proc, Method, #===]
    # @param conds [Proc, Method, #===]
    # @return [lambda]
    #   this lambda return true if match a any condition
    def OR(cond1, cond2, *conds)
      _logical_operator :any?, cond1, cond2, *conds
    end

    # A condition builder.
    # @param cond1 [Proc, Method, #===]
    # @param cond2 [Proc, Method, #===]
    # @param conds [Proc, Method, #===]
    # @return [lambda]
    def NOR(cond1, cond2, *conds)
      NOT OR(cond1, cond2, *conds)
    end

    # A condition builder.
    # @param cond1 [Proc, Method, #===]
    # @param cond2 [Proc, Method, #===]
    # @param conds [Proc, Method, #===]
    # @return [lambda]
    def XOR(cond1, cond2, *conds)
      _logical_operator :one?, cond1, cond2, *conds
    end
    
    # A condition builder.
    # @param cond1 [Proc, Method, #===]
    # @param cond2 [Proc, Method, #===]
    # @param conds [Proc, Method, #===]
    # @return [lambda] 
    def XNOR(cond1, cond2, *conds)
      NOT XOR(cond1, cond2, *conds)
    end

    # A condition builder.
    # @param condition [Proc, Method, #===]
    # @return [lambda] A condition invert the original condition.
    def NOT(condition)
      unless conditionable? condition
        raise TypeError, 'wrong object for condition'
      end
      
      ->v{! _valid?(condition, v)}
    end

    # A condition builder.
    # @param obj [#==]
    # @return [lambda]
    #   this lambda return true if a argment match under #== method
    def EQ(obj)
      ->v{obj == v}
    end

    # A condition builder.
    # @param obj [#equal?]
    # @return [lambda]
    #   this lambda return true if a argment match under #equal? method
    def EQUAL(obj)
      ->v{obj.equal? v}
    end

    alias_method :SAME, :EQUAL
    module_function :SAME

    # A condition builder.
    # @param messages [Symbol, String]
    # @return [lambda]
    #   this lambda return true if a argment respond to all messages
    def CAN(message1, *messages)
      messages = [message1, *messages]
      unless messages.all?{|s|
                [Symbol, String].any?{|klass|s.kind_of? klass}
              }
        raise TypeError, 'only Symbol or String for message'
      end
      
      ->v{
        messages.all?{|message|v.respond_to? message}
      }
    end

    # A condition builder.
    # @param condition [Proc, Method, #===]
    # @param conditions [Proc, Method, #===]
    # @return [lambda]
    #   this lambda return true
    #   if face no exception when a argment checking under all conditions 
    def QUIET(condition, *conditions)
      conditions = [condition, *conditions]
      unless conditions.all?{|c|conditionable? c}
        raise TypeError, 'wrong object for condition'
      end
      
      ->v{
        conditions.all?{|cond|
          begin
            _valid? cond, v
          rescue Exception
            false
          else
            true
          end
        }
      }
    end
    
    # A condition builder.
    # @param exception [Exception]
    # @param exceptions [Exception]
    # @return [lambda]
    #   this lambda return true
    #   if catch any kindly exceptions when a argment checking in a block parameter
    def RESCUE(exception, *exceptions, &condition)
      exceptions = [exception, *exceptions]
      raise ArgumentError unless conditionable? condition
      raise TypeError unless exceptions.all?{|e|e.ancestors.include? Exception}
      
      ->v{
        begin
          _valid? condition, v
        rescue *exceptions
          true
        rescue Exception
          false
        else
          false
        end
      }
    end

    # A condition builder.
    # @param exception [Exception]
    # @return [lambda]
    #   this lambda return true
    #   if catch a specific exception when a argment checking in a block parameter
    def CATCH(exception, &condition)
      raise ArgumentError unless conditionable? condition
      raise TypeError, 'not error object' unless exception.ancestors.include? Exception
      
      ->v{
        begin
          _valid? condition, v
        rescue Exception
          $!.instance_of? exception
        else
          false
        end
      }
    end

    # A condition builder.
    # @param condition [Proc, Method, #===]
    # @param conditions [Proc, Method, #===]
    # @return [lambda]
    #   this lambda return true
    #   if all included objects match all conditions
    def ALL(condition, *conditions)
      conditions = [condition, *conditions]
      unless conditions.all?{|c|conditionable? c}
        raise TypeError, 'wrong object for condition'
      end
      
      ->list{
        enum = (
          (list.respond_to?(:each_value) && list.each_value) or
          (list.respond_to?(:all?) && list) or
          (list.respond_to?(:each) && list.each) or
          return false
        )
      
        conditions.all?{|cond|
          enum.all?{|v|
            _valid? cond, v
          }
        }
      }
    end

    alias_method :GENERICS, :ALL
    module_function :GENERICS
    
    # A condition builder.
    # @param list [#all?]
    # @param lists [#all?]
    # @return [lambda]
    #   this lambda return true
    #   if all lists including the object
    def MEMBER_OF(list, *lists)
      lists = [list, *lists]
      unless lists.all?{|l|l.respond_to? :all?}
        raise TypeError, 'list must respond #all?'
      end
      
      ->v{
        lists.all?{|l|l.include? v}
      }
    end

    # @endgroup
    
    # @group Useful Conditions
    ANYTHING = BasicObject # BasicObject.=== always passing
    BOOLEAN = ->v{v.equal?(true) || v.equal?(false)}
    STRINGABLE = OR(String, Symbol, CAN(:to_str), CAN(:to_sym))
    
    module_function

    def ANYTHING?
      ANYTHING
    end
    
    # A getter for a useful condition.
    # @return [BOOLEAN] "true or false"
    def BOOLEAN?
      BOOLEAN
    end
    
    alias_method :BOOL?, :BOOLEAN?
    module_function :BOOL?

    # A getter for a useful condition.
    # @return [STRINGABLE] check "looks string family"
    def STRINGABLE?
      STRINGABLE
    end
    
    # @endgroup

  end

end