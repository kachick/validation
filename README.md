validation
==========

[![Build Status](https://secure.travis-ci.org/kachick/validation.png)](http://travis-ci.org/kachick/validation)

Description
-----------

Support validations

Features
--------

* Provide a way of defining validations anywhere.
* Easy and Flexible validation combinators.
* And adjusters.
* Pure Ruby :)

Usage
-----

### Overview - Validatable for accessor with validation

```ruby
require 'validation'

class Person

  include Validation
      
  attr_validator :name, String
  attr_validator :id, OR(nil, AND(Integer, 1..100))

end
```

### How to build a flexible condition

* See the API doc

### More Examples

See below libraries

* [striuct](https://github.com/kachick/striuct)
* [io-nosey](https://github.com/kachick/io-nosey)
* [family](https://github.com/kachick/family)

Requirements
-------------

* [Ruby 1.9.2 or later](http://travis-ci.org/#!/kachick/validation)

Install
-------

```bash
$ gem install validation
```

Link
----

* [code](https://github.com/kachick/validation)
* [API](http://kachick.github.com/validation/yard/frames.html)
* [issues](https://github.com/kachick/validation/issues)
* [CI](http://travis-ci.org/#!/kachick/validation)
* [gem](https://rubygems.org/gems/validation)

License
--------

The MIT X11 License  
Copyright (c) 2011-2012 Kenichi Kamiya  
See the file LICENSE for further details.