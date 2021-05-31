# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestValidationAdjustmentOld < Test::Unit::TestCase
  class Sth
    include Validation

    attr_validator :age, Numeric, &->arg{Integer arg}
  end

  def setup
    @sth = Sth.new
    assert_same nil, @sth.age
  end

  def test_procedure
    @sth.age = 10
    assert_same 10, @sth.age
    @sth.age = 10.0
    assert_same 10, @sth.age

    assert_raises Validation::InvalidAdjustingError do
      @sth.age = '10.0'
    end

    @sth.age = '10'
    assert_same 10, @sth.age
  end
end

class TestValidationAdjustment < Test::Unit::TestCase
  class MyClass
    def self.parse(v)
      raise unless /\A[a-z]+\z/ =~ v
      new
    end
  end

  class Sth
    include Validation

    attr_validator :chomped, AND(Symbol, NOT(/\n/)), &WHEN(String, ->v{v.chomp!.to_sym})
    attr_validator :no_reduced, Symbol, &->v{v.to_sym}
    attr_validator :reduced, Symbol, &INJECT(->v{v.foo}, ->v{v.to_sym})
    attr_validator :integer, Integer, &PARSE(Integer)
    attr_validator :myobj, ->v{v.instance_of? MyClass}, &PARSE(MyClass)
  end

  def test_WHEN
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.chomped = :"a\n"
    end

    assert_raises Validation::InvalidAdjustingError do
      sth.chomped = 'a'
    end

    sth.chomped = :a

    assert_equal :a, sth.chomped

    sth.chomped = :b
    assert_equal :b, sth.chomped
  end

  def test_REDUCE
    sth = Sth.new
    obj = Object.new

    obj.singleton_class.class_eval do
      def foo
        'This is strings :)'
      end
    end

    assert_raises Validation::InvalidAdjustingError do
      sth.no_reduced = obj
    end

    sth.reduced = obj

    assert_equal :'This is strings :)', sth.reduced
  end

  def test_PARSE
    sth = Sth.new

    assert_raises Validation::InvalidAdjustingError do
      sth.integer = '1.0'
    end

    sth.integer = '1'

    assert_equal 1, sth.integer

    assert_raises Validation::InvalidAdjustingError do
      sth.myobj = '1'
    end

    sth.myobj = 'a'

    assert_kind_of MyClass, sth.myobj
  end
end
