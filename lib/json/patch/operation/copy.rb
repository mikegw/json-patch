# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class Copy < Base
        attr_reader :from

        def call(document)
          from_target = document.fetch(@from)
          document.add(path, duplicate(from_target))
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
