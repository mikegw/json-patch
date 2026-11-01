# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  # `skip` replaces the deprecated `add_filter` in simplecov 1.x, but older
  # versions (needed on older Rubies) only have `add_filter`.
  respond_to?(:skip) ? skip('spec') : add_filter('spec')
end

require 'json/patch'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
