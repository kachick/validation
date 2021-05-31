# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestExamples < Test::Unit::TestCase
  class Person
    include Validation

    attr_accessor_with_validation :id, OR(nil, AND(Integer, 1..100))
    attr_accessor_with_validation :name, AND(String, /Ken/)
    attr_accessor_with_validation :age, AND(Integer, 12..125), &:to_i
  end

  def test_examples
    person = Person.new

    assert_raises(Validation::InvalidReadingError) do
      person.name
    end

    assert_nil(person.id)

    assert_raises(Validation::InvalidWritingError) do
      person.name = :Ken
    end
    assert_raises(Validation::InvalidWritingError) do
      person.name = 'John'
    end
    assert_raises(Validation::InvalidReadingError) do
      person.name
    end

    assert_raises(Validation::InvalidWritingError) do
      person.id = 200
    end

    assert_nil(person.id)

    person.name = (ken = 'Ken')
    assert_same(ken, person.name)
    person.id = 42
    assert_equal(42, person.id)

    assert_raises(Validation::InvalidWritingError) do
      person.age = 11.9
    end

    person.age = 12.9
    assert_equal(12, person.age)
  end
end
