# coding: us-ascii

require 'test/unit'
require_relative '../lib/validation'

if Warning.respond_to?(:[]=)
  Warning[:deprecated] = true
  Warning[:experimental] = true
end
