# I don't know why dose occur errors below.
#  require_relative 'lib/validation/version'
require File.expand_path('../lib/validation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.description   = %q{A way of defining validations anywhere.}
  gem.summary       = %q{A way of defining validations anywhere.}
  gem.homepage      = 'https://github.com/kachick/validation'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features|declare)/})
  gem.name          = 'validation'
  gem.require_paths = ['lib']
  gem.version       = Validation::VERSION.dup # dup for https://github.com/rubygems/rubygems/commit/48f1d869510dcd325d6566df7d0147a086905380#-P0

  gem.required_ruby_version = '>= 1.9.2'
  gem.add_development_dependency 'yard', '>= 0.8.2.1'
  gem.add_development_dependency 'rdoc', '>= 3.12'
end