# frozen_string_literal: true

RSpec.describe JSON::Patch::Document do
  describe '.build' do
    it 'supports additions' do
      document = described_class.build do |doc|
        doc.add '/foo', value: 'bar'
      end

      expect(document.to_json).to eq('[{"op":"add","path":"/foo","value":"bar"}]')
    end

    it 'supports copies' do
      document = described_class.build do |doc|
        doc.copy from: '/foo', path: '/bar'
      end

      expect(document.to_json).to eq('[{"op":"copy","from":"/foo","path":"/bar"}]')
    end

    it 'supports moves' do
      document = described_class.build do |doc|
        doc.move from: '/foo', path: '/bar'
      end

      expect(document.to_json).to eq('[{"op":"move","from":"/foo","path":"/bar"}]')
    end

    it 'supports removals' do
      document = described_class.build do |doc|
        doc.remove '/foo'
      end

      expect(document.to_json).to eq('[{"op":"remove","path":"/foo"}]')
    end

    it 'supports replacements' do
      document = described_class.build do |doc|
        doc.replace '/foo', value: 'bar'
      end

      expect(document.to_json).to eq('[{"op":"replace","path":"/foo","value":"bar"}]')
    end

    it 'supports tests' do
      document = described_class.build do |doc|
        doc.test '/foo', value: 'bar'
      end

      expect(document.to_json).to eq('[{"op":"test","path":"/foo","value":"bar"}]')
    end
  end
end
