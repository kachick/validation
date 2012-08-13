require 'rubygems'
gem 'hoe', '~> 3.0.7'
require 'hoe'
require 'fileutils'

Hoe.plugin :newgem

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'validation' do
  developer 'Kenichi Kamiya', 'kachick1+ruby@gmail.com'
  self.rubyforge_name       = self.name
  require_ruby_version '>= 1.9.2'
  dependency 'yard', '~> 0.8.2.1', :development
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
