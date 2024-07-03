# JSON::Patch [![Ruby](https://github.com/mikegw/json-patch/actions/workflows/main.yml/badge.svg)](https://github.com/mikegw/json-patch/actions/workflows/main.yml) [![GitHub version](https://badge.fury.io/gh/mikegw%2Fjson-patch.svg)](https://badge.fury.io/gh/mikegw%2Fjson-patch)

A bare-bones implementation of [RFC 6902](https://datatracker.ietf.org/doc/html/rfc6902).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add json-patch --github mikegw/json-patch

or add the following to your gemfile:

    $ gem 'json-patch', github: 'mikegw/json-patch'

## Usage
The simplest way to use this library is to provide a target document string and a patch document string to `JSON::Patch.call`.
This will return a new JSON string with the patch document applied.

```ruby
target_document = '{"foos":["foo"]}'
patch_document = '{"op":"add","path":"/foos/-","another foo"}'

patch_result_document = JSON::Patch.call(target_document, patch_document)
patch_result_document  #=> '{"foos":["foo","another foo"]}'
```

This library also exposes a few classes to wrap JSON documents:

```ruby
target_document = JSON::Patch::TargetDocument.new(target_document)
patch_document = JSON::Patch::Document.new(patch_document)

patch_document.apply(target_document)

target_document.to_json #=> '{"foos":["foo","another foo"]}'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, commit and push the repo to github, and then use github to create a release tag.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mikegw/json-patch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/json-patch/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JSON::Patch project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/json-patch/blob/main/CODE_OF_CONDUCT.md).
