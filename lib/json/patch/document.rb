# frozen_string_literal: true

module JSON
  module Patch
    class Document
      class Error < Patch::Error; end
    end
  end
end

require_relative 'document/pointer'
