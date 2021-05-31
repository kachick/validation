# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestGetterValidation < Test::Unit::TestCase
  class Sth
    include Validation

    attr_accessor_with_validation :plus_getter, /./, writer_validation: true, reader_validation: true
    attr_accessor_with_validation :only_getter, /./, writer_validation: false, reader_validation: true
  end

  def test_writer_validation
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.plus_getter = ''
    end

    sth.plus_getter = +'abc'
    assert_equal 'abc', sth.plus_getter
    sth.plus_getter.clear

    assert_raises Validation::InvalidReadingError do
      sth.plus_getter
    end

    sth.only_getter = ''

    assert_raises Validation::InvalidReadingError do
      sth.only_getter
    end
  end
end
