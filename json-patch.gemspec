# frozen_string_literal: true

require_relative 'lib/json/patch/version'

Gem::Specification.new do |spec|
  spec.name = 'json-patch'

  spec.version = JSON::Patch::VERSION
  spec.authors = ['Mike Williamson']
  spec.email = ['mail@mikegw.me']

  spec.summary = 'A gem to apply JSON patch documents.'

  spec.homepage = 'https://github.com/mikegw/json-patch'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mikegw/json-patch'
  spec.metadata['changelog_uri'] = 'https://github.com/mikegw/json-patch/CHANGELOG.md'

  spec.files =
    Dir.glob('lib/**/*') +
    Dir.glob('sig/**/*') +
    %w[CHANGELOG.md CODE_OF_CONDUCT.md LICENSE.txt README.md]

  spec.require_paths = ['lib']

  spec.add_dependency 'duplicate', '~> 1'
  spec.add_dependency 'json-pointer', '~> 1'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
