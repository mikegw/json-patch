# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Test < Base
        attr_reader :value

        def call(document)
          actual = document.fetch(path)
          return if actual == value

          message = "Test failed: expected #{path} to equal #{value}, got #{actual}"
          raise TestFailed, message
        end

        private

        def populate!
          super
          @value = fetch_member(:value, allow_nil: true)
        end
      end
    end
  end
end
