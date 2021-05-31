# coding: us-ascii
# frozen_string_literal: true

module Validation
  module Adjustment
    module_function

    # @group Support Building Adjusters

    # true if argument is sufficient for adjuster.
    # A adjuster have to be arity equal 1.
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

    # Adjuster Builders
    # Apply adjuster when passed condition.
    # @param condition [Proc, Method, #===]
    # @param adjuster [Proc, #to_proc]
    # @return [lambda]
    def WHEN(condition, adjuster)
      unless Validation.conditionable?(condition)
        raise TypeError, 'wrong object for condition'
      end

      unless Validation.adjustable?(adjuster)
        raise TypeError, 'wrong object for adjuster'
      end

      ->v { _valid?(condition, v) ? adjuster.call(v) : v }
    end

    # Sequential apply all adjusters.
    # @param adjuster1 [Proc, #to_proc]
    # @param adjuster2 [Proc, #to_proc]
    # @param adjusters [Proc, #to_proc]
    # @return [lambda]
    def INJECT(adjuster1, adjuster2, *adjusters)
      adjusters = [adjuster1, adjuster2, *adjusters]

      unless adjusters.all? { |f| adjustable?(f) }
        raise TypeError, 'wrong object for adjuster'
      end

      ->v {
        adjusters.reduce(v) { |ret, adjuster| adjuster.call(ret) }
      }
    end

    # Accept any parser when that respond to parse method.
    # @param parser [#parse]
    # @return [lambda]
    def PARSE(parser)
      if !::Integer.equal?(parser) && !parser.respond_to?(:parse)
        raise TypeError, 'wrong object for parser'
      end

      ->v {
        if ::Integer.equal?(parser)
          ::Kernel.Integer(v)
        else
          parser.parse(
            case v
            when String
              v
            when ->_ { v.respond_to?(:to_str) }
              v.to_str
            when ->_ { v.respond_to?(:read) }
              v.read
            else
              raise TypeError, 'wrong object for parsing source'
            end
          )
        end
      }
    end

    # @endgroup
  end
end
