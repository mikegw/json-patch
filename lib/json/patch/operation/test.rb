# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Test < Base
        def call(document)
          path = fetch_member('path')
          expected = fetch_member('value', allow_nil: true)

          actual = document.fetch(path)
          return if expected == actual

          raise Error, "Test failed: expected #{path} to equal #{expected}, got #{actual}"
        end
      end
    end
  end
end
