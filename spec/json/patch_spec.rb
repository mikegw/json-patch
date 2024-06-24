# frozen_string_literal: true

require 'json'

JSON.parse(File.read(File.join(__dir__, '../tests.json')))

RSpec.describe JSON::Patch do
  it 'has a version number' do
    expect(JSON::Patch::VERSION).not_to be_nil
  end

  context 'when combining operations' do
    let(:patch_document) { <<~PATCH }
      [
        {"op": "move", "from": "/old", "path": "/new"},
        {"op": "replace", "path": "/new", "value": "copy me"},
        {"op": "copy", "from": "/new", "path": "/copied"},
        {"op": "test", "path": "/copied", "value": "copy me"},
        {"op": "add", "path": "/foo", "value": {"bar": "baz"}},
        {"op": "copy", "from": "/foo", "path": "/foo-copy"},
        {"op": "remove", "path": "/foo/bar"},
        {"op": "test", "path": "/foo-copy", "value": {"bar": "baz"}}
      ]
    PATCH

    it 'applies all operations in order' do
      target_document = '{"old":"move me"}'

      result = described_class.call(target_document, patch_document)

      expect(result).to eq(
        '{"new":"copy me","copied":"copy me","foo":{},"foo-copy":{"bar":"baz"}}'
      )
    end

    it 'does not modify the original document' do
      target_document = '{"old":"move me"}'

      described_class.call(target_document, patch_document)

      expect(target_document).to eq('{"old":"move me"}')
    end
  end
end
