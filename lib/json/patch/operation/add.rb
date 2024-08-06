# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Add < Base
        attr_reader :value

        def call(document)
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
