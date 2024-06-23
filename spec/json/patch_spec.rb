# frozen_string_literal: true

require 'json'

JSON.parse(File.read(File.join(__dir__, '../tests.json')))

RSpec.describe JSON::Patch do
  it 'has a version number'

  describe 'an "add" operation' do
    it 'must contain a "path" member'

    it 'must contain a "value" member'

    context 'when the target location specifies an array index' do
      it 'inserts a new value into the array at the specified index, ' \
         'shifting any elements at or above the specified index ' \
         'one position to the right'
    end

    context 'when the target location specifies an array index matching ' \
            'the number of elements in the array' do
      it 'appends the provided value to the array'
    end

    context 'when the target location specifies an array index greater than' \
            'the number of elements in the array' do
      it 'fails to apply the patch document'
    end

    context 'when the target location specifies "-" as the array index' do
      it 'appends the provided value to the array'
    end

    context 'when the target location specifies an object member ' \
            'that does not already exist' do
      it 'adds a new member to the object'
    end

    context 'when the target location specifies an object member ' \
            'that does exist' do
      it 'replaces the member\'s value'
    end

    context 'when the container of the target location does not exist' do
      it 'fails to apply the patch document'
    end
  end

  describe 'a "remove" operation' do
    it 'must contain a "path" member'

    it 'removes the value at the target location'

    context 'when the target location does not exist' do
      it 'raises an error'
    end

    context 'when removing an element from an array' do
      it 'shifts any elements above the specified index ' \
         'one position to the left'
    end
  end

  describe 'a "replace" operation' do
    it 'must contain a "path" member'

    it 'must contain a "value" member'

    it 'replaces the value at the target location with a new value'

    context 'when the target location does not exist' do
      it 'raises an error'
    end
  end

  describe 'a "move" operation' do
    it 'must contain a "path" member'

    it 'must contain a "from" member'

    it 'removes the value at a specified "from" location ' \
       'and adds it to the target location'

    context 'when the "from" location does not exist' do
      it 'raises an error'
    end

    context 'when the "from" location is a proper prefix ' \
            'of the "path" location' do
      it 'raises an error'
    end
  end

  describe 'a "copy" operation' do
    it 'must contain a "path" member'

    it 'must contain a "from" member'

    it 'copies the value at a specified "from" location ' \
       'and adds it to the target location'

    context 'when the "from" location does not exist' do
      it 'raises an error'
    end
  end

  describe 'a "test" operation' do
    it 'must contain a "path" member'

    it 'must contain a "value" member'

    context 'when the target location value is a string' do
      it 'accepts a matching test string'

      it 'rejects a string that does not match'

      it 'rejects a number'
    end

    context 'when the target location value is a number' do
      it 'accepts a matching test number'

      it 'rejects a number that does not match'

      it 'rejects a string'
    end

    context 'when the target location value is an array' do
      it 'accepts a matching test array'

      it 'rejects an array that does not match'
    end

    context 'when the target location value is an object' do
      it 'accepts a matching test object'

      it 'rejects an object that does not match'

      it 'accepts a differently-ordered matching test object'
    end

    context 'when the target location value is the literal `true`' do
      it 'accepts a matching test literal'

      it 'rejects a literal that does not match'

      it 'rejects a string representation'
    end

    context 'when the target location value is the literal `false`' do
      it 'accepts a matching test literal'

      it 'rejects a literal that does not match'

      it 'rejects a string representation'
    end

    context 'when the target location value is the literal `null`' do
      it 'accepts a matching test literal'

      it 'rejects a literal that does not match'

      it 'rejects a string representation'
    end
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

    it 'applies all operations in order'

    it 'does not modify the original document'
  end
end
