# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestValidationFunctionalCondition < Test::Unit::TestCase
  class Sthlambda
    include Validation

    def lanks
      1..20
    end

    attr_validator :lank, ->lank{lanks.include? lank}
  end

  def test_lambda
    sth = Sthlambda.new
    sth.lank = 2
    assert_equal 2, sth.lank

    assert_raises Validation::InvalidWritingError do
      sth.lank = 31
    end
  end

  class SthProc
    include Validation

    attr_validator :lank, ->n {(3..9) === n}
  end

  def test_Proc
    sth = SthProc.new
    sth.lank = 8
    assert_equal 8, sth.lank

    assert_raises Validation::InvalidWritingError do
      sth.lank = 2
    end
  end

  class SthMethod
    include Validation

    attr_validator :lank, 7.method(:<)
  end

  def test_Method
    sth = SthMethod.new
    sth.lank = 8
    assert_equal 8, sth.lank

    assert_raises Validation::InvalidWritingError do
      sth.lank = 6
    end
  end
end
