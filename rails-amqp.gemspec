# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'rails/amqp/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'rails-amqp'
  spec.version     = Rails::Amqp::VERSION
  spec.authors     = ['Ronaldo de Sousa Araujo']
  spec.email       = ['contato@ronaldoaraujo.eti.br']
  spec.homepage    = 'https://github.com/ronaldoaraujo/rails-amqp'
  spec.summary     = 'Used for integrations between rails micro-services.'
  spec.description = 'The rails plugin for AMQP'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'bunny', '~> 2.11.0'
  spec.add_dependency 'daemons-rails', '~> 1.2'
  spec.add_dependency 'rails', '~> 6.0.2'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
