# frozen_string_literal: true

module JSON
  module Patch
    class Document
      class Builder
        attr_reader :operations

        def initialize
          @operations = []
        end

        def add(path, value:)
          @operations << Operation.new(op: 'add', path: path, value: value)
        end

        def copy(from:, path:)
          @operations << Operation.new(op: 'copy', from: from, path: path)
        end

        def move(from:, path:)
          @operations << Operation.new(op: 'move', from: from, path: path)
        end

        def remove(path)
          @operations << Operation.new(op: 'remove', path: path)
        end

        def replace(path, value:)
          @operations << Operation.new(op: 'replace', path: path, value: value)
        end

        def test(path, value:)
          @operations << Operation.new(op: 'test', path: path, value: value)
        end
      end
    end
  end
end
