# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestValidationSpecialConditions < Test::Unit::TestCase
  EQUALITY_CHECKER = ':)'.freeze

  class Sth
    include Validation

    attr_accessor_with_validation :list_only_int, SEND(:all?, Integer)
    attr_accessor_with_validation :always_passing, ANYTHING()
    attr_accessor_with_validation :true_or_false, BOOLEAN()
    attr_accessor_with_validation :has_foo, CAN(:foo)
    attr_accessor_with_validation :has_foo_and_bar, CAN(:foo, :bar)
    attr_accessor_with_validation :has_ignore, AND(1..5, 3..10)
    attr_accessor_with_validation :nand, NAND(1..5, 3..10)
    attr_accessor_with_validation :all_pass, OR(1..5, 3..10)
    attr_accessor_with_validation :rescue_error, RESCUE(NameError, ->v{v.no_name!})
    attr_accessor_with_validation :no_exception, QUIET(->v{v.class})
    attr_accessor_with_validation :not_integer, NOT(Integer)
    attr_accessor_with_validation :eq, EQ(EQUALITY_CHECKER)
    attr_accessor_with_validation :same, SAME(EQUALITY_CHECKER)
  end

  def test_anything
    sth = Sth.new

    obj = BasicObject.new

    sth.always_passing = obj
    assert_same obj, sth.always_passing
  end

  def test_not
    sth = Sth.new

    obj = Object.new

    sth.not_integer = obj
    assert_same obj, sth.not_integer

    assert_raises Validation::InvalidWritingError do
      sth.not_integer = 1
    end
  end

  def test_quiet
    sth = Sth.new

    obj = Object.new

    sth.no_exception = obj
    assert_same obj, sth.no_exception
    sth.no_exception = false

    obj.singleton_class.class_eval do
      undef_method :class
    end

    assert_raises Validation::InvalidWritingError do
      sth.no_exception = obj
    end
  end

  def test_rescue
    sth = Sth.new

    obj = Object.new

    sth.rescue_error = obj
    assert_same obj, sth.rescue_error
    sth.rescue_error = false

    obj.singleton_class.class_eval do
      def no_name!
      end
    end

    assert_raises Validation::InvalidWritingError do
      sth.rescue_error = obj
    end

    obj.singleton_class.class_eval do
      remove_method :no_name!

      def no_name!
        raise NameError
      end
    end

    sth.rescue_error = obj
    assert_same obj, sth.rescue_error
  end

  def test_or
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.all_pass = 11
    end

    sth.all_pass = 1
    assert_equal 1, sth.all_pass
    sth.all_pass = 4
    assert_equal 4, sth.all_pass
  end

  def test_and
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.has_ignore = 1
    end

    assert_raises Validation::InvalidWritingError do
      sth.has_ignore = 2
    end

    sth.has_ignore = 3
    assert_equal 3, sth.has_ignore
    assert_raises Validation::InvalidWritingError do
      sth.has_ignore = []
    end
  end

  def test_nand
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.nand = 4
    end

    assert_raises Validation::InvalidWritingError do
      sth.nand = 4.5
    end

    sth.nand = 2
    assert_equal 2, sth.nand
    sth.nand = []
    assert_equal [], sth.nand
  end

  def test_all
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.list_only_int = [1, '2']
    end

    sth.list_only_int = [1, 2]
    assert_equal [1, 2], sth.list_only_int
    sth.list_only_int = []
    assert_equal [], sth.list_only_int
  end

  def test_boolean
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.true_or_false = nil
    end

    sth.true_or_false = true
    assert_equal true, sth.true_or_false
    sth.true_or_false = false
    assert_equal false, sth.true_or_false
  end

  def test_responsible_arg1
    sth = Sth.new
    obj = Object.new

    raise if obj.respond_to? :foo

    assert_raises Validation::InvalidWritingError do
      sth.has_foo = obj
    end

    obj.singleton_class.class_eval do
      def foo
      end
    end

    raise unless obj.respond_to? :foo

    sth.has_foo = obj
    assert_equal obj, sth.has_foo
  end

  def test_responsible_arg2
    sth = Sth.new
    obj = Object.new

    raise if obj.respond_to? :foo
    raise if obj.respond_to? :bar

    assert_raises Validation::InvalidWritingError do
      sth.has_foo_and_bar = obj
    end

    obj.singleton_class.class_eval do
      def foo
      end
    end

    raise unless obj.respond_to? :foo

    assert_raises Validation::InvalidWritingError do
      sth.has_foo_and_bar = obj
    end

    obj.singleton_class.class_eval do
      def bar
      end
    end

    raise unless obj.respond_to? :bar

    sth.has_foo_and_bar = obj
    assert_equal obj, sth.has_foo_and_bar
  end

  def test_eq
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.eq = (EQUALITY_CHECKER.dup << ':(')
    end

    sth.eq = EQUALITY_CHECKER.dup
    assert_equal EQUALITY_CHECKER, sth.eq
  end

  def test_same
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.same = EQUALITY_CHECKER.dup
    end

    sth.same = EQUALITY_CHECKER
    assert_same EQUALITY_CHECKER, sth.same
  end
end
