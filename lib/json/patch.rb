# frozen_string_literal: true

require_relative 'patch/version'

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
