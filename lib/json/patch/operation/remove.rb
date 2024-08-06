# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Remove < Base
        def call(document)
          document.remove(path)
        end
      end
    end
  end
end
