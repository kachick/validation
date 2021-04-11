# coding: us-ascii

lib_name = 'validation'.freeze
require "./lib/#{lib_name}/version"
repository_url = 'https://github.com/kachick/validation'

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{Validations with Ruby objects.}
  gem.summary       = gem.description.dup
  gem.homepage      = repository_url
  gem.license       = 'MIT'
  gem.name          = lib_name.dup
  gem.version       = Validation::VERSION.dup

  gem.required_ruby_version = '>= 2.5'
  gem.add_development_dependency 'yard', '>= 0.9.26', '< 2'
  gem.add_development_dependency 'rake', '>= 13.0.3', '< 20'
  gem.add_development_dependency 'test-unit', '>= 3.4.0', '< 4'

  gem.metadata = {
    'documentation_uri' => 'https://rubydoc.info/github/kachick/validation/',
    'homepage_uri'      => repository_url,
    'source_code_uri'   => repository_url,
  }

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
