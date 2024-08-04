# frozen_string_literal: true

require 'forwardable'
require 'duplicate'

require_relative 'document/builder'

module JSON
  module Patch
    class Document
      include Enumerable
      include Duplicate

      extend Forwardable

      def self.build
        builder = Builder.new
        yield builder

        new(builder.operations)
      end

      def initialize(raw)
        raw_operations = raw.is_a?(String) ? JSON.parse(raw) : duplicate(raw)
        raw_operations.each { _1.transform_keys!(&:to_sym) }

        @operations = raw_operations.map { Operation.new(_1) }
      end

      def apply(target_document)
        each { _1.call(target_document) }
      end

      def_delegator :@operations, :each
      def_delegator :@operations, :to_json
    end
  end
end
