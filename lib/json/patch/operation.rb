# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      def self.new(raw_operation)
        case raw_operation['op']
        when 'add' then Add.new(raw_operation)
        when 'remove' then Remove.new(raw_operation)
        when 'replace' then Replace.new(raw_operation)
        when 'move' then Move.new(raw_operation)
        when 'copy' then Copy.new(raw_operation)
        when 'test' then Test.new(raw_operation)
        else
          raise Error, "Unsupported operation: #{raw_operation['op'].inspect}"
        end
      end

      class Base
        def initialize(raw)
          @raw = raw
        end

        def call(_document)
          raise NoMethodError, "#{self.class} is missing an implementation of #call"
        end

        private

        def fetch_member(key, allow_nil: false)
          raise Error, "Operation missing required member: #{key}" unless @raw.key?(key)

          if !allow_nil && @raw[key].nil?
            raise Error, "Invalid value for key #{key.inspect}: `null`"
          end

          @raw[key]
        end
      end
    end
  end
end

require_relative 'operation/add'
require_relative 'operation/remove'
require_relative 'operation/replace'
require_relative 'operation/move'
require_relative 'operation/copy'
require_relative 'operation/test'
