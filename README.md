# validation

![Build Status](https://github.com/kachick/validation/actions/workflows/test_behaviors.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/validation.png)](http://badge.fury.io/rb/validation)

Validations with Ruby objects.

## Usage

Require Ruby 2.5 or later

Add below code into your Gemfile

```ruby
gem 'validation', '>= 0.2.0', '< 0.3.0'
```

```ruby
require 'validation'

class Person
  include Validation

  attr_validator :name, String
  attr_validator :id, OR(nil, AND(Integer, 1..100))
end

person = Person.new
person.name = :Ken  #=> Error (Symbol is not String)
person.id   = 200   #=> Error (200 is not covered by 1..100)
person.name = 'Ken' #=> Pass
person.id   = 1     #=> Pass
```

### More Examples

* [striuct](https://github.com/kachick/striuct)
* [optionalargument](https://github.com/kachick/optionalargument)
* [family](https://github.com/kachick/family)

## Links

* [Repository](https://github.com/kachick/validation)
* [API documents](https://kachick.github.io/validation)
