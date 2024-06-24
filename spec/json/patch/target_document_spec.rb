# frozen_string_literal: true

RSpec.describe JSON::Patch::TargetDocument do
  describe '#fetch' do
    it 'can fetch the whole document' do
      pointer = ''
      document = described_class.new('foo' => 'bar')

      expect(document.fetch(pointer)).to eq('foo' => 'bar')
    end

    it 'can fetch a simple object key' do
      pointer = '/foo'
      document = described_class.new('foo' => 'bar')

      expect(document.fetch(pointer)).to eq('bar')
    end

    it 'can fetch a nested object key' do
      pointer = '/foo/bar'
      document = described_class.new('foo' => { 'bar' => 'baz' })

      expect(document.fetch(pointer)).to eq('baz')
    end

    it 'can fetch an array element' do
      pointer = '/0'
      document = described_class.new(%w[foo])

      expect(document.fetch(pointer)).to eq('foo')
    end

    it 'can fetch the last element in an array' do
      pointer = '/-'
      document = described_class.new(%w[foo bar])

      expect(document.fetch(pointer)).to eq('bar')
    end

    context 'when fetching a location that does not exist' do
      it 'raises an error' do
        pointer = '/missing_key'
        document = described_class.new('foo' => 'bar')

        expect { document.fetch(pointer) }
          .to raise_error(described_class::Error)
      end
    end

    context 'when fetching an index that does not exist' do
      it 'raises an error' do
        pointer = '/1'
        document = described_class.new(['x'])

        expect { document.fetch(pointer) }
          .to raise_error(described_class::Error)
      end
    end
  end

  describe '#add' do
    context 'when adding a value to an object' do
      it 'sets the key and value of the object' do
        pointer = '/foo'
        document = described_class.new({})

        document.add(pointer, 'bar')

        expect(document.fetch('')).to eq('foo' => 'bar')
      end
    end

    context 'when adding an element to an array' do
      it 'inserts the element at the correct position' do
        pointer = '/1'
        document = described_class.new(%w[a c])

        document.add(pointer, 'b')

        expect(document.fetch('')).to eq(%w[a b c])
      end
    end

    context 'when the index is too large to add to an array' do
      it 'raises an error' do
        pointer = '/2'
        document = described_class.new([])

        expect { document.add(pointer, 'a') }
          .to raise_error(described_class::Error)
      end
    end

    context 'when attempting to add a value at a negative index' do
      it 'raises an error' do
        pointer = '/-1'
        document = described_class.new(['x'])

        expect { document.add(pointer, 'y') }
          .to raise_error(JSON::Patch::Error)
      end
    end

    context 'when attempting to adding an element to a value' do
      it 'raises an error' do
        pointer = '/foo/bar'
        document = described_class.new('foo' => 'not an object')

        expect { document.add(pointer, 'baz') }
          .to raise_error(described_class::Error)
      end
    end

    context 'when the pointer does not point to a valid container' do
      it 'raises an error' do
        pointer = '/missing_key/bar'
        document = described_class.new('foo' => {})

        expect { document.add(pointer, 'baz') }
          .to raise_error(described_class::Error)
      end
    end

    context 'when adding a value with an empty path' do
      it 'replaces the entire document' do
        pointer = ''
        document = described_class.new({ 'foo' => 'bar' })

        document.add(pointer, 'baz')

        expect(document.fetch('')).to eq('baz')
      end
    end
  end

  describe '#remove' do
    context 'when removing a value from an object' do
      it 'removes the key and value of the object' do
        pointer = '/foo'
        document = described_class.new('foo' => 'bar')

        document.remove(pointer)

        expect(document.fetch('')).to eq({})
      end
    end

    context 'when removing an element from an array' do
      it 'removes the element at the correct position' do
        pointer = '/1'
        document = described_class.new(%w[a b c])

        document.remove(pointer)

        expect(document.fetch('')).to eq(%w[a c])
      end
    end

    context 'when attempting to remove an element from a value' do
      it 'raises an error' do
        pointer = '/foo/bar'
        document = described_class.new('foo' => 'not an object')

        expect { document.remove(pointer) }
          .to raise_error(described_class::Error)
      end
    end

    context 'when the pointer does not point to a valid object key' do
      it 'raises an error' do
        pointer = '/missing_key'
        document = described_class.new('foo' => 'bar')

        expect { document.remove(pointer) }
          .to raise_error(described_class::Error)
      end
    end

    context 'when the pointer does not point to a valid array element' do
      it 'raises an error' do
        pointer = '/1'
        document = described_class.new(['x'])

        expect { document.remove(pointer) }
          .to raise_error(described_class::Error)
      end
    end

    context 'when removing with an empty path' do
      it 'removes the entire document' do
        pointer = ''
        document = described_class.new({ 'foo' => 'bar' })

        document.remove(pointer)

        expect(document.fetch('')).to be_nil
      end
    end
  end
end
