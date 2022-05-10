# coding: us-ascii
# frozen_string_literal: true

require 'warning'

# How to use => https://test-unit.github.io/test-unit/en/
require 'test/unit'

require 'irb'
require 'power_assert/colorize'
require 'irb/power_assert'

Warning.process do |_warning|
  :raise
end

require_relative '../lib/validation'
