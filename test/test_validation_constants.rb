# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

class TestConstants < Test::Unit::TestCase
  def test_constant_version
    assert do
      Validation::VERSION.instance_of?(String)
    end

    assert do
      Validation::VERSION.frozen?
    end

    assert do
      Gem::Version.correct?(Validation::VERSION)
    end
  end
end
