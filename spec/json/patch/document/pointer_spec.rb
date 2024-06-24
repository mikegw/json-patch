# frozen_string_literal: true

RSpec.describe JSON::Patch::Document::Pointer do
  it 'can be empty' do
    pointer = described_class.new('')

    expect(pointer.reference_tokens).to be_empty
  end

  it 'requires reference tokens to start with a "/"' do
    expect { described_class.new('foo') }
      .to raise_error(described_class::Error, /Invalid pointer/)
  end

  it 'can parse a single object key' do
    pointer = described_class.new('/foo')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq(%w[foo])
  end

  it 'can parse nested object keys' do
    pointer = described_class.new('/foo/bar/baz')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq(%w[foo bar baz])
  end

  it 'recognizes empty object keys' do
    pointer = described_class.new('/')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq([''])
  end

  it 'recognizes whitespace object keys' do
    pointer = described_class.new('/ ')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq([' '])
  end

  it 'supports integer object keys' do
    pointer = described_class.new('/0')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq(%w[0])
  end

  it 'decodes escaped "~" characters' do
    pointer = described_class.new('/m~0n')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq(%w[m~n])
  end

  it 'decodes escaped "/" characters' do
    pointer = described_class.new('/a~1b')

    tokens = pointer.reference_tokens

    expect(tokens.map(&:to_s)).to eq(%w[a/b])
  end

  describe 'the tokens returned' do
    context 'when a token represents a number' do
      it 'can be converted to an integer' do
        pointer = described_class.new('/0')

        tokens = pointer.reference_tokens

        expect(tokens.map(&:to_i)).to eq([0])
      end
    end

    context 'when a token starts with a leading zero' do
      it 'can not be converted to an array index' do
        pointer = described_class.new('/00')

        tokens = pointer.reference_tokens

        expect { tokens.map(&:to_i) }
          .to raise_error(described_class::Error, /can not convert/)
      end
    end

    context 'when a token does not represent a number' do
      it 'can not be converted to an integer' do
        pointer = described_class.new('/foo')

        tokens = pointer.reference_tokens

        expect { tokens.map(&:to_i) }
          .to raise_error(described_class::Error, /can not convert/)
      end
    end

    context 'when a token represents the last element in an array' do
      it 'is converted to `-1`' do
        pointer = described_class.new('/-')

        tokens = pointer.reference_tokens

        expect(tokens.map(&:to_i)).to eq([-1])
      end
    end
  end
end
