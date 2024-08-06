# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Move < Base
        attr_reader :from

        def call(document)
          removed = document.remove(from)
          document.add(path, removed)
        end

        private

        def populate!
          super
          @from = fetch_member(:from)
        end
      end
    end
  end
end
