# frozen_string_literal: true

module JSON
  module Patch
    class Error < StandardError; end
    class InvalidOperation < Error; end
    class InvalidPointer < Error; end
    class MissingTarget < Error; end
    class TestFailed < Error; end
    class TokenOutOfRange < Error; end
    class UnknownOperation < Error; end

    class << self
      def call(raw_target_document, raw_patch_document)
        target_document = TargetDocument.new(raw_target_document)
        patch_document = Document.new(raw_patch_document)

        patch_document.apply(target_document)

        target_document.to_json
      end
    end
  end
end

require_relative 'patch/document'
require_relative 'patch/operation'
require_relative 'patch/target_document'
require_relative 'patch/version'
