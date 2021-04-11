validation
==========

![Build Status](https://github.com/kachick/validation/actions/workflows/test.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/validation.png)](http://badge.fury.io/rb/validation)

Description
-----------

Validations with Ruby objects.

Features
--------

* Pure Ruby :)

Usage
-----
### An optional extension for accessor with validation.

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
* [io-nosey](https://github.com/kachick/io-nosey)
* [family](https://github.com/kachick/family)

Requirements
-------------

* Ruby 2.5 or later

Install
-------

```bash
gem install validation
```

Link
----

* [API documentation](https://rubydoc.info/github/kachick/validation/)

License
--------

The MIT X11 License  
Copyright (c) 2011-2012 Kenichi Kamiya  
See MIT-LICENSE for further details.
