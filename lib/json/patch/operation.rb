# frozen_string_literal: true

module JSON
  module Patch
    module Operation
      class << self
        def new(**raw_operation)
          raw_operation = raw_operation.transform_keys(&:to_sym)
          operation_class = determine_operation_class(raw_operation[:op])

          operation_class.new(**raw_operation)
        end

        private

        def determine_operation_class(name)
          case name
          when 'add' then Add
          when 'copy' then Copy
          when 'move' then Move
          when 'remove' then Remove
          when 'replace' then Replace
          when 'test' then Test
          else raise UnknownOperation, "Unsupported operation: #{name.inspect}"
          end
        end
      end

      class Base
        attr_reader :path

        def initialize(**raw)
          @raw = raw.transform_keys(&:to_sym)

          populate!
        end

        def call(_document)
          raise NoMethodError, "#{self.class} is missing an implementation of #call"
        end

        def as_json(*)
          @raw
        end

        def to_json(*_args)
          @raw.to_json
        end

        private

        def fetch_member(key, allow_nil: false)
          unless @raw.key?(key)
            raise InvalidOperation, "Operation missing required member: #{key}"
          end

          if !allow_nil && @raw[key].nil?
            raise InvalidOperation, "Invalid value for key #{key.inspect}: `null`"
          end

          @raw[key]
        end

        def populate!
          @path = fetch_member(:path)

          JSON::Pointer.new(@path) # will throw error if invalid path
        rescue JSON::Pointer::Error => e
          raise InvalidPointer, e.message
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
