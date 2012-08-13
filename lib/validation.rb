# Copyright (C) 2011-2012 Kenichi Kamiya

# @example Overview
#   class Person
#     include Validation
#     attr_validator :name, String
#   end
module Validation
end

require_relative 'validation/version'
require_relative 'validation/errors'
require_relative 'validation/condition'
require_relative 'validation/adjustment'
require_relative 'validation/validatable'
require_relative 'validation/singletonclass'
require_relative 'validation/module_functions'
