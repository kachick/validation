# coding: us-ascii

require File.expand_path('../lib/validation/version', __FILE__)

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{A way of defining validations on anywhere.}
  gem.summary       = %q{A way of defining validations on anywhere.}
  gem.homepage      = 'http://kachick.github.com/validation/'
  gem.license       = 'MIT'
  gem.name          = 'validation'
  gem.version       = Validation::VERSION.dup

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_development_dependency 'yard', '>= 0.8.7.3', '< 0.9'
  gem.add_development_dependency 'rake', '>= 10', '< 20'
  gem.add_development_dependency 'bundler', '>= 1.3.5', '< 2'

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

end