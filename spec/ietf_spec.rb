# frozen_string_literal: true

require 'json'

tests = JSON.parse(File.read(File.join(__dir__, './tests.json')))

RSpec.describe JSON::Patch, 'satisfies the IETF patch tests' do
  tests.each_with_index do |test, index|
    next if test['disabled']

    if test['error']
      it "satisfies Test #{index}: #{test['error']}" do
        document = test['doc'].to_json
        patch = test['patch'].to_json

        expect { described_class.call(document, patch) }
          .to raise_error(described_class::Error)
      end
    else
      it "satisfies Test #{index}#{": #{test['comment']}" if test.key?('comment')}" do
        document = test['doc'].to_json
        patch = test['patch'].to_json

        result = JSON.parse(described_class.call(document, patch))

        expect(result).to eq(test['expected']) if test.key?('expected')
      end
    end
  end
end
