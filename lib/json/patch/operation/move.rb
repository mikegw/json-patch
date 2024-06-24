# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Move < Base
        def call(document)
          path = fetch_member('path')
          from = fetch_member('from')

          removed = document.remove(from)
          document.add(path, removed)
        end
      end
    end
  end
end
