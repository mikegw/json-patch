# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Remove < Base
        def call(document)
          path = fetch_member('path')

          document.remove(path)
        end
      end
    end
  end
end
