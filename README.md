validation
==========

[![Build Status](https://secure.travis-ci.org/kachick/validation.png)](http://travis-ci.org/kachick/validation)
[![Gem Version](https://badge.fury.io/rb/validation.png)](http://badge.fury.io/rb/validation)

Description
-----------

I think validations are not only for Web Apps :)

Features
--------

* Provide a way of defining validations anywhere
* Easy and Flexible validation combinators
* And adjusters
* Pure Ruby :)

Usage
-----

### How to build flexible conditions

* See the [API doc](http://kachick.github.com/validation/yard/frames.html)

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

* [Ruby 1.9.3 or later](http://travis-ci.org/#!/kachick/validation)

Install
-------

```bash
gem install validation
```

Link
----

* [Home](http://kachick.github.com/validation/)
* [code](https://github.com/kachick/validation)
* [API](http://kachick.github.com/validation/yard/frames.html)
* [issues](https://github.com/kachick/validation/issues)
* [CI](http://travis-ci.org/#!/kachick/validation)
* [gem](https://rubygems.org/gems/validation)

License
--------

The MIT X11 License  
Copyright (c) 2011-2012 Kenichi Kamiya  
See MIT-LICENSE for further details.