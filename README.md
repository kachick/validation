- _**This repository is archived**_
- _**No longer maintained**_
- _**All versions have been yanked from https://rubygems.org for releasing valuable namespace for others**_

# validation

![Build Status](https://github.com/kachick/validation/actions/workflows/test_behaviors.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/validation.svg)](http://badge.fury.io/rb/validation)

Validations with Ruby objects.

## Usage

Require Ruby 2.7 or later

Add below code into your Gemfile

```ruby
gem 'validation', '~> 0.4.1'
```

### Overview

```ruby
require 'validation'

class Person
  include Validation

  attr_accessor_with_validation :id, OR(nil, AND(Integer, 1..100))
  attr_accessor_with_validation :name, AND(String, /Ken/)
  attr_accessor_with_validation :age, AND(Integer, 12..125), &:to_i
end

person = Person.new

person.id #=> nil
person.name #=> Error (nil is not String)

person.id   = 200   #=> Error (200 is not covered by `1..100`)
person.id   = 42
person.id #=> 42

person.name = :Ken  #=> Error (Symbol is not String)
person.name = 'John'  #=> Error ("John" is not matched to `/Ken/`)
person.name = 'Ken'
person.name #=> "Ken"

person.age = 11.9 #=> Error ( `11.9` adjusting to `11` with `(11.9).to_i`, but it is not covered by `12..125`)
person.age = 12.9
person.age #=> 12
```

The pattern builder DSL is just using [eqq](https://github.com/kachick/eqq)

## Links

* [Repository](https://github.com/kachick/validation)
* [API documents](https://kachick.github.io/validation)
