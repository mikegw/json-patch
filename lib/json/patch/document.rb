# frozen_string_literal: true

require 'forwardable'
require 'duplicate'

module JSON
  module Patch
    class Document
      include Enumerable
      include Duplicate

      extend Forwardable

      attr_reader :operations

      def initialize(raw)
        raw_operations = raw.is_a?(String) ? JSON.parse(raw) : duplicate(raw)

        @operations = raw_operations.map { Operation.new(_1) }
      end

      def apply(target_document)
        each { _1.call(target_document) }
      end

      def_delegator :@operations, :each
    end
  end
end
