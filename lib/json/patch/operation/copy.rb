# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Copy < Base
        def call(document)
          path = fetch_member(:path)
          from = fetch_member(:from)

          from_target = document.fetch(from)
          document.add(path, duplicate(from_target))
        end
      end
    end
  end
end
