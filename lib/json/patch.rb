# frozen_string_literal: true

module JSON
  module Patch
    class Error < StandardError; end

    class << self
      def call(document, _patch)
        document
      end
    end
  end
end

require_relative 'patch/document'
require_relative 'patch/target_document'
require_relative 'patch/version'
