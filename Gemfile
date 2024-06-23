# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in json-patch.gemspec
gemspec

gem 'rake', '~> 13.0'

group :test do
  gem 'rspec'
end

group :development do
  gem 'rubocop', '1.63.5'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false

  gem 'simplecov', '~> 0.22.0'
end
