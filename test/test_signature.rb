# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestSignature < Test::Unit::TestCase
  def test_attr_reader_with_validation
    assertion_context = self

    Class.new do
      extend Validation::Validatable::ClassMethods

      assertion_context.assert_equal(:foo, attr_reader_with_validation(:foo, 42))
      assertion_context.assert_equal(:bar=, attr_writer_with_validation(:bar, 42))
      assertion_context.assert_equal([:baz, :baz=], attr_accessor_with_validation(:baz, 42))
    end
  end
end
