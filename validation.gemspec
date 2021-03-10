# coding: us-ascii

lib_name = 'validation'.freeze
require "./lib/#{lib_name}/version"

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{Validations with Ruby objects.}
  gem.summary       = gem.description.dup
  gem.homepage      = "http://kachick.github.com/#{lib_name}/"
  gem.license       = 'MIT'
  gem.name          = lib_name.dup
  gem.version       = Validation::VERSION.dup

  gem.required_ruby_version = '>= 1.9.3' # Tested in 2.2 or later version.
  gem.add_development_dependency 'yard', '>= 0.9.9', '< 2'
  gem.add_development_dependency 'rake', '>= 10', '< 20'
  gem.add_development_dependency 'test-unit', '>= 3.2.6', '< 4'

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

end
