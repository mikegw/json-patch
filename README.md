# JSON::Patch [![Ruby](https://github.com/mikegw/json-patch/actions/workflows/main.yml/badge.svg)](https://github.com/mikegw/json-patch/actions/workflows/main.yml) [![GitHub version](https://badge.fury.io/gh/mikegw%2Fjson-patch.svg)](https://badge.fury.io/gh/mikegw%2Fjson-patch)

A bare-bones implementation of [RFC 6902](https://datatracker.ietf.org/doc/html/rfc6902).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add json-patch --github mikegw/json-patch

or add the following to your gemfile:

    $ gem 'json-patch', github: 'mikegw/json-patch'

## Usage

### Applying Patch Documents

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

### Building Patch Documents

This library exposes a DSL for building patch documents as follows:

```ruby
patch_document = JSON::Patch::Document.build do |doc|
  doc.add '/foo', value: 'bar'
  doc.copy from: '/foo', path: '/bar'
  doc.move from: '/bar', path: '/baz'
  doc.remove '/foo'
  doc.replace '/baz', value: 'baz'
  doc.test '/baz', value: 'baz'
end

patch_document.to_json #=>
# '[
#    {"op":"add", "path":"/foo", "value":"bar"},
#    {"op":"copy", "from":"/foo", "path":"/bar"},
#    {"op":"move", "from":"/bar", "path":"/baz"},
#    {"op":"remove", "path":"/foo"},
#    {"op":"replace", "path":"/baz", "value":"baz"},
#    {"op":"test", "path":"/baz", "value":"baz"}
#  ]'
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
