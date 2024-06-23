# frozen_string_literal: true

require_relative 'lib/json/patch/version'

Gem::Specification.new do |spec|
  spec.name = 'json-patch'
  spec.version = JSON::Patch::VERSION
  spec.authors = ['Mike Williamson']
  spec.email = ['mike@cardflight.com']

  spec.summary = 'A gem to apply JSON patch documents.'
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = 'https://github.com/cardflight/json-patch'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/cardflight/json-patch'
  spec.metadata['changelog_uri'] = 'https://github.com/cardflight/json-patch/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
