# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Add < Base
        def call(document)
          path = fetch_member(:path)
          value = fetch_member(:value, allow_nil: true)

          document.add(path, value)
        end
      end
    end
  end
end
