# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Replace < Base
        attr_reader :value

        def call(document)
          document.remove(path)
          document.add(path, value)
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
