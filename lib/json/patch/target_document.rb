# frozen_string_literal: true

require 'duplicate'
require 'json/pointer'

module JSON
  module Patch
    class TargetDocument
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

      def as_json(*)
        @raw
      end

      def to_json(*args)
        @raw.to_json(*args)
      end

      private

      def split_pointer(raw_pointer)
        pointer = JSON::Pointer.new(raw_pointer)

        container = fetch_container(pointer.reference_tokens)
        last_token = pointer.reference_tokens.last || empty_token

        [container, last_token]
      rescue JSON::Pointer::Error => e
        raise InvalidPointer, e.message
      end

      def fetch_container(reference_tokens)
        validate_container!(@raw, empty_token, reference_tokens.first || empty_token)
        return @raw if reference_tokens.none?

        reference_tokens.each_cons(2).inject(@raw) do |raw_document, tokens|
          # @type var tokens:[JSON::Pointer::ReferenceToken,JSON::Pointer::ReferenceToken]
          token, next_token = tokens

          container = fetch_reference(raw_document, token)
          validate_container!(container, token, next_token)

          container
        end
      end

      def fetch_reference(raw_document, token)
        validate_index!(raw_document, token)
        validate_key!(raw_document, token)

        raw_document[token]
      end

      def validate_container!(raw_document, token, next_token)
        return if raw_document.is_a?(Hash)

        expected = /^(0|[1-9][0-9]*|-)$/.match?(next_token.to_s) ? :array : :object
        return if raw_document.is_a?(Array) && expected == :array

        raise MissingTarget, "expected #{token} to reference an #{expected}"
      end

      def validate_index!(container, token, allow_next_element: false)
        return unless container.is_a?(Array)

        return if token.to_i < container.length
        return if token.to_i == container.length && allow_next_element

        raise TokenOutOfRange, "token out of range: #{token}"
      rescue JSON::Pointer::Error => e
        raise InvalidPointer, e.message
      end

      def validate_key!(container, token)
        return unless container.is_a?(Hash)

        return if container.key?(token)

        raise MissingTarget, "target does not exist at location: #{token}"
      end

      def empty_token
        JSON::Pointer::ReferenceToken.new('')
      end
    end
  end
end
