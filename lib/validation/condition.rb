module Validation

  module Condition

    module_function

    # @group Support Building Conditions
    
    # true if object is sufficient for condition.
    # @param [Object] object
    def conditionable?(object)
      case object
      when ANYTHING
        true
      when Proc, Method
        object.arity == 1
      else
        object.respond_to? :===
      end
    end
  
    # Condition Builders
    # A innner method for some condition builders.
    # For build conditions AND, NAND, OR, NOR, XOR, XNOR.
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
    # @return [lambda]
    #   this lambda return true if match all conditions
    def AND(cond1, cond2, *conds)
      _logical_operator :all?, cond1, cond2, *conds
    end
  
    # A condition builder.
    # @return [lambda] 
    def NAND(cond1, cond2, *conds)
      NOT AND(cond1, cond2, *conds)
    end

    # A condition builder.
    # @return [lambda]
    #   this lambda return true if match a any condition
    def OR(cond1, cond2, *conds)
      _logical_operator :any?, cond1, cond2, *conds
    end

    # A condition builder.
    # @return [lambda] 
    def NOR(cond1, cond2, *conds)
      NOT OR(cond1, cond2, *conds)
    end

    # A condition builder.
    # @return [lambda] 
    def XOR(cond1, cond2, *conds)
      _logical_operator :one?, cond1, cond2, *conds
    end
    
    # A condition builder.
    # @return [lambda] 
    def XNOR(cond1, cond2, *conds)
      NOT XOR(cond1, cond2, *conds)
    end

    # A condition builder.
    # @return [lambda] A condition invert the original condition.
    def NOT(condition)
      unless conditionable? condition
        raise TypeError, 'wrong object for condition'
      end
      
      ->v{! _valid?(condition, v)}
    end

    # A condition builder.
    # @return [lambda]
    #   this lambda return true if a argment match under #== method
    def EQUAL(obj)
      ->v{obj == v}
    end

    # A condition builder.
    # @return [lambda]
    #   this lambda return true if a argment match under #equal? method
    def SAME(obj)
      ->v{obj.equal? v}
    end

    # A condition builder.
    # @param [Symbol, String] messages
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
    # @return [lambda]
    #   this lambda return true
    #   if face no exception when a argment checking under all conditions 
    def QUIET(condition1, *conditions)
      conditions = [condition1, *conditions]
      unless conditions.all?{|c|conditionable? c}
        raise TypeError, 'wrong object for condition'
      end
      
      ->v{
        conditions.all?{|condition|
          begin
            _valid? condition, v
          rescue Exception
            false
          else
            true
          end
        }
      }
    end
    
    # A condition builder.
    # @return [lambda]
    #   this lambda return true
    #   if catch any kindly exceptions when a argment checking in a block parameter
    def RESCUE(_exception, *exceptions, &condition)
      exceptions = [_exception, *exceptions]
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
          $!.class.equal? exception
        else
          false
        end
      }
    end

    # A condition builder.
    # @return [lambda]
    #   this lambda return true
    #   if all included objects match all conditions
    def GENERICS(condition1, *conditions)
      conditions = [condition1, *conditions]
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
      
        conditions.all?{|condition|
          enum.all?{|v|
            _valid? condition, v
          }
        }
      }
    end
    
    # A condition builder.
    # @return [lambda]
    #   this lambda return true
    #   if all lists including the object
    def MEMBER_OF(list1, *lists)
      lists = [list1, *lists]
      unless lists.all?{|l|l.respond_to? :all?}
        raise TypeError, 'list must respond #all?'
      end
      
      ->v{
        lists.all?{|list|list.include? v}
      }
    end

    # @endgroup
    
    # @group Useful Conditions

    ANYTHING = Object.new.freeze
    BOOLEAN = ->v{[true, false].any?{|bool|bool.equal? v}}
    STRINGABLE = OR(String, Symbol, CAN(:to_str), CAN(:to_sym))
    
    module_function
    
    # The getter for a special condition.
    # @return [ANYTHING] A condition always pass with any objects.
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