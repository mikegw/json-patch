# frozen_string_literal: true

require 'duplicate'
require 'json/pointer'

module JSON
  module Patch
    class TargetDocument
      class Error < Patch::Error; end

      def initialize(raw)
        @raw = raw.is_a?(String) ? JSON.parse(raw) : duplicate(raw)
      end

      def fetch(raw_pointer)
        return @raw if raw_pointer.empty?

        container, last_token = split_pointer(raw_pointer)
        fetch_reference(container, last_token)
      end

      def add(raw_pointer, value)
        return @raw = value if raw_pointer.empty?

        container, last_token = split_pointer(raw_pointer)
        validate_index!(container, last_token, allow_next_element: true)

        add_method = container.is_a?(Array) ? :insert : :store
        container.send(add_method, last_token, value)
      end

      def remove(raw_pointer)
        return @raw = nil if raw_pointer.empty?

        container, last_token = split_pointer(raw_pointer)
        validate_index!(container, last_token)
        validate_key!(container, last_token)

        remove_method = container.is_a?(Array) ? :delete_at : :delete
        container.send(remove_method, last_token)
      end

      def to_json(*)
        JSON.generate(@raw, *) if @raw
      end

      private

      def split_pointer(raw_pointer)
        pointer = JSON::Pointer.new(raw_pointer)
        *container_reference_tokens, last_token = pointer.reference_tokens
        # @type var last_token: JSON::Pointer::ReferenceToken

        container = fetch_container(container_reference_tokens)

        [container, last_token]
      rescue JSON::Pointer::Error => e
        raise Error, e.message
      end

      def fetch_container(reference_tokens)
        validate_container!(@raw, JSON::Pointer::ReferenceToken.new(''))
        return @raw if reference_tokens.none?

        reference_tokens.inject(@raw) do |raw_document, token|
          container = fetch_reference(raw_document, token)
          validate_container!(container, token)

          container
        end
      end

      def fetch_reference(raw_document, token)
        validate_index!(raw_document, token)
        validate_key!(raw_document, token)

        raw_document[token]
      end

      def validate_container!(raw_document, token)
        return if raw_document.is_a?(Array) || raw_document.is_a?(Hash)

        raise Error, "expected #{token} to reference a container"
      end

      def validate_index!(container, token, allow_next_element: false)
        return unless container.is_a?(Array)

        return if token.to_i < container.length
        return if token.to_i == container.length && allow_next_element

        raise Error, "token out of range: #{token}"
      rescue JSON::Pointer::Error => e
        raise Error, e.message
      end

      def validate_key!(container, token)
        return unless container.is_a?(Hash)

        return if container.key?(token)

        raise Error, "target does not exist at location: #{token}"
      end
    end
  end
end
