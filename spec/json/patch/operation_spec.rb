# frozen_string_literal: true

RSpec.describe JSON::Patch::Operation do
  describe 'an "add" operation' do
    it 'must contain a "path" member' do
      target = JSON::Patch::TargetDocument.new('{}')
      operation = described_class.new({ 'op' => 'add', 'value' => 'foo' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'must contain a "value" member' do
      target = JSON::Patch::TargetDocument.new('{}')
      operation = described_class.new({ 'op' => 'add', 'path' => '/foo' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    context 'when the target location specifies an array index' do
      it 'inserts a new value into the array at the specified index, ' \
         'shifting any elements at or above the specified index ' \
         'one position to the right' do
        target = JSON::Patch::TargetDocument.new('{"a":["x","z"]}')
        operation =
          described_class.new('op' => 'add', 'path' => '/a/1', 'value' => 'y')

        operation.call(target)

        expect(target.to_json).to eq('{"a":["x","y","z"]}')
      end
    end

    context 'when the target location specifies an array index matching ' \
            'the number of elements in the array' do
      it 'appends the provided value to the array' do
        target = JSON::Patch::TargetDocument.new('{"a":["x","y"]}')
        operation =
          described_class.new('op' => 'add', 'path' => '/a/2', 'value' => 'z')

        operation.call(target)

        expect(target.to_json).to eq('{"a":["x","y","z"]}')
      end
    end

    context 'when the target location specifies an array index greater than' \
            'the number of elements in the array' do
      it 'fails to apply the patch document' do
        target = JSON::Patch::TargetDocument.new('{"a":["x","z"]}')
        operation =
          described_class.new('op' => 'add', 'path' => '/a/3', 'value' => 'y')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the target location specifies "-" as the array index' do
      it 'appends the provided value to the array' do
        target = JSON::Patch::TargetDocument.new('{"a":["x","y"]}')
        operation =
          described_class.new('op' => 'add', 'path' => '/a/-', 'value' => 'z')

        operation.call(target)

        expect(target.to_json).to eq('{"a":["x","y","z"]}')
      end
    end

    context 'when the target location specifies an object member ' \
            'that does not already exist' do
      it 'adds a new member to the object' do
        target = JSON::Patch::TargetDocument.new('{"key":"value"}')
        operation =
          described_class.new('op' => 'add', 'path' => '/other', 'value' => 'yay')

        operation.call(target)

        expect(target.to_json).to eq('{"key":"value","other":"yay"}')
      end
    end

    context 'when the target location specifies an object member ' \
            'that does exist' do
      it 'replaces the member\'s value' do
        target = JSON::Patch::TargetDocument.new('{"key":"value"}')
        operation =
          described_class.new('op' => 'add', 'path' => '/key', 'value' => 'new value')

        operation.call(target)

        expect(target.to_json).to eq('{"key":"new value"}')
      end
    end

    context 'when the container of the target location does not exist' do
      it 'fails to apply the patch document' do
        target = JSON::Patch::TargetDocument.new('{"key":"value"}')
        operation =
          described_class.new('op' => 'add', 'path' => '/nested/key', 'value' => 'boo')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end
  end

  describe 'a "remove" operation' do
    it 'must contain a "path" member' do
      target = JSON::Patch::TargetDocument.new('{"foo":"bar"}')
      operation = described_class.new({ 'op' => 'remove' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'removes the value at the target location' do
      target = JSON::Patch::TargetDocument.new('{"foo":"bar"}')
      operation = described_class.new({ 'op' => 'remove', 'path' => '/foo' })

      operation.call(target)

      expect(target.to_json).to eq('{}')
    end

    context 'when the target location does not exist' do
      it 'raises an error' do
        target = JSON::Patch::TargetDocument.new('{"foo":"bar"}')
        operation = described_class.new({ 'op' => 'remove', 'path' => '/missing' })

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when removing an element from an array' do
      it 'shifts any elements above the specified index ' \
         'one position to the left' do
        target = JSON::Patch::TargetDocument.new('{"a":["x","y","z"]}')
        operation = described_class.new({ 'op' => 'remove', 'path' => '/a/1' })

        operation.call(target)

        expect(target.to_json).to eq('{"a":["x","z"]}')
      end
    end
  end

  describe 'a "replace" operation' do
    it 'must contain a "path" member' do
      target = JSON::Patch::TargetDocument.new('{}')
      operation = described_class.new({ 'op' => 'replace', 'value' => 'foo' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'must contain a "value" member' do
      target = JSON::Patch::TargetDocument.new('{}')
      operation = described_class.new({ 'op' => 'replace', 'path' => '/foo' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'replaces the value at the target location with a new value' do
      target = JSON::Patch::TargetDocument.new('{"a":["x","z"]}')
      operation =
        described_class.new('op' => 'replace', 'path' => '/a/1', 'value' => 'y')

      operation.call(target)

      expect(target.to_json).to eq('{"a":["x","y"]}')
    end

    context 'when the target location does not exist' do
      it 'raises an error' do
        target = JSON::Patch::TargetDocument.new('{"foo":"bar"}')
        operation =
          described_class.new('op' => 'replace', 'path' => '/missing', 'value' => 'baz')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end
  end

  describe 'a "move" operation' do
    it 'must contain a "path" member' do
      target = JSON::Patch::TargetDocument.new('{"old":"move me"}')
      operation = described_class.new({ 'op' => 'move', 'from' => '/old' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'must contain a "from" member' do
      target = JSON::Patch::TargetDocument.new('{"old":"move me"}')
      operation = described_class.new({ 'op' => 'move', 'path' => '/new' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'removes the value at a specified "from" location ' \
       'and adds it to the target location' do
      target = JSON::Patch::TargetDocument.new('{"old":"move me"}')
      operation =
        described_class.new('op' => 'move', 'from' => '/old', 'path' => '/new')

      operation.call(target)

      expect(target.to_json).to eq('{"new":"move me"}')
    end

    context 'when the "from" location does not exist' do
      it 'raises an error' do
        target = JSON::Patch::TargetDocument.new('{"old":"move me"}')
        operation =
          described_class.new('op' => 'move', 'from' => '/missing', 'path' => '/new')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the "from" location is a proper prefix ' \
            'of the "path" location' do
      it 'raises an error' do
        target = JSON::Patch::TargetDocument.new('{"old":"move me"}')
        operation =
          described_class.new('op' => 'move', 'from' => '/a', 'path' => '/a/b')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end
  end

  describe 'a "copy" operation' do
    it 'must contain a "path" member' do
      target = JSON::Patch::TargetDocument.new('{"old":"copy me"}')
      operation = described_class.new({ 'op' => 'copy', 'from' => '/old' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'must contain a "from" member' do
      target = JSON::Patch::TargetDocument.new('{"old":"copy me"}')
      operation = described_class.new({ 'op' => 'copy', 'path' => '/new' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'copies the value at a specified "from" location ' \
       'and adds it to the target location' do
      target = JSON::Patch::TargetDocument.new('{"old":"copy me"}')
      operation =
        described_class.new('op' => 'copy', 'from' => '/old', 'path' => '/new')

      operation.call(target)

      expect(target.to_json).to eq('{"old":"copy me","new":"copy me"}')
    end

    context 'when the "from" location does not exist' do
      it 'raises an error' do
        target = JSON::Patch::TargetDocument.new('{"old":"copy me"}')
        operation =
          described_class.new('op' => 'copy', 'from' => '/missing', 'path' => '/new')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end
  end

  describe 'a "test" operation' do
    it 'must contain a "path" member' do
      target = JSON::Patch::TargetDocument.new('{}')
      operation = described_class.new({ 'op' => 'test', 'value' => 'foo' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    it 'must contain a "value" member' do
      target = JSON::Patch::TargetDocument.new('{}')
      operation = described_class.new({ 'op' => 'test', 'path' => '/foo' })

      expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
    end

    context 'when the target location value is a string' do
      it 'accepts a matching test string' do
        target = JSON::Patch::TargetDocument.new('{"foo":"bar"}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 'bar')

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects a string that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":"bar"}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 'not bar')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end

      it 'rejects a number' do
        target = JSON::Patch::TargetDocument.new('{"foo":"1"}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 1)

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the target location value is a number' do
      it 'accepts a matching test number' do
        target = JSON::Patch::TargetDocument.new('{"foo":1}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 1)

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects a number that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":1}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 2)

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end

      it 'rejects a string' do
        target = JSON::Patch::TargetDocument.new('{"foo":1}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => '1')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the target location value is an array' do
      it 'accepts a matching test array' do
        target = JSON::Patch::TargetDocument.new('{"foo":[1]}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => [1])

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects an array that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":[1]}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => [2])

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the target location value is an object' do
      it 'accepts a matching test object' do
        target = JSON::Patch::TargetDocument.new('{"foo":[1]}')
        operation =
          described_class.new('op' => 'test', 'path' => '', 'value' => { 'foo' => [1] })

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects an object that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":[1]}')
        operation =
          described_class.new('op' => 'test', 'path' => '', 'value' => { 'foo' => [2] })

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end

      it 'accepts a differently-ordered matching test object' do
        target = JSON::Patch::TargetDocument.new('{"a":"b","c":"d"}')
        test_value = { 'c' => 'd', 'a' => 'b' }

        operation =
          described_class.new('op' => 'test', 'path' => '', 'value' => test_value)

        expect { operation.call(target) }.not_to raise_error
      end
    end

    context 'when the target location value is the literal `true`' do
      it 'accepts a matching test literal' do
        target = JSON::Patch::TargetDocument.new('{"foo":true}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => true)

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects a literal that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":true}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => false)

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end

      it 'rejects a string representation' do
        target = JSON::Patch::TargetDocument.new('{"foo":true}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 'true')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the target location value is the literal `false`' do
      it 'accepts a matching test literal' do
        target = JSON::Patch::TargetDocument.new('{"foo":false}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => false)

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects a literal that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":false}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => true)

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end

      it 'rejects a string representation' do
        target = JSON::Patch::TargetDocument.new('{"foo":false}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 'false')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end

    context 'when the target location value is the literal `null`' do
      it 'matches nil' do
        target = JSON::Patch::TargetDocument.new('{"foo":null}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => nil)

        expect { operation.call(target) }.not_to raise_error
      end

      it 'rejects a literal that does not match' do
        target = JSON::Patch::TargetDocument.new('{"foo":null}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => false)

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end

      it 'rejects a string representation' do
        target = JSON::Patch::TargetDocument.new('{"foo":null}')
        operation =
          described_class.new('op' => 'test', 'path' => '/foo', 'value' => 'null')

        expect { operation.call(target) }.to raise_error(JSON::Patch::Error)
      end
    end
  end
end
