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
          @operations << { op: 'add', path: path, value: value }
        end

        def copy(from:, path:)
          @operations << { op: 'copy', from: from, path: path }
        end

        def move(from:, path:)
          @operations << { op: 'move', from: from, path: path }
        end

        def remove(path)
          @operations << { op: 'remove', path: path }
        end

        def replace(path, value:)
          @operations << { op: 'replace', path: path, value: value }
        end

        def test(path, value:)
          @operations << { op: 'test', path: path, value: value }
        end
      end
    end
  end
end
