# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in json-patch.gemspec
gemspec

gem 'json-pointer', '~> 1.0', github: 'mikegw/json-pointer'

group :test do
  gem 'rspec'
  gem 'simplecov'
end

group :development do
  gem 'rake'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false

  gem 'rbs', '~> 3.5'
  gem 'steep'
end
