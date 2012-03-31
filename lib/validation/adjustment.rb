# Copyright (C) 2011-2012  Kenichi Kamiya

module Validation

  module Adjustment
    class UnmanagebleError < InvalidError; end
  
    # Adjuster Builders
    module Builders
      # true if argument is sufficient for adjuster.
      # A adjuster have to be arity equal 1.
      # @param [Object] object
      def adjustable?(object)
        case object
        when Proc
          object.arity == 1
        else
          if object.respond_to?(:to_proc)
            object.to_proc.arity == 1
          else
            false
          end
        end
      end
    end

    # Apply adjuster when passed condition.
    # @return [lambda]
    def WHEN(condition, adjuster)
      raise TypeError, 'wrong object for condition' unless conditionable? condition
      raise TypeError, 'wrong object for adjuster' unless adjustable? adjuster
      
      ->v{pass?(v, condition) ? adjuster.call(v) : v}
    end
    
    # Sequencial apply all adjusters.
    # @return [lambda]
    def INJECT(adjuster1, adjuster2, *adjusters)
      adjusters = [adjuster1, adjuster2, *adjusters]

      unless adjusters.all?{|f|adjustable? f}
        raise TypeError, 'wrong object for adjuster'
      end

      ->v{
        adjusters.reduce(v){|ret, adjuster|adjuster.call ret}
      }
    end

    # Accept any parser when that resopond to parse method.
    # @return [lambda]
    def PARSE(parser)
      if !::Integer.equal?(parser) and !parser.respond_to?(:parse)
        raise TypeError, 'wrong object for parser'
      end
      
      ->v{
        if ::Integer.equal? parser
          ::Kernel.Integer v
        else
          parser.parse(
            case v
            when String
              v
            when ->_{v.respond_to? :to_str}
              v.to_str
            when ->_{v.respond_to? :read}
              v.read            
            else
              raise TypeError, 'wrong object for parsing source'
            end
          )
        end
      }
    end

    # Useful Adjusters
    module Patterns
      include Builders
    end
  end

end