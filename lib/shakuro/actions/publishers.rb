# frozen_string_literal: true

module Shakuro
  module Actions
    # Provides functions to access actions on publishers
    module Publishers
      require_relative 'publishers/index_shops'

      # Returns associative array with information about shops selling at least
      # one book copy of the publisher
      # @param [Object] params
      #   object of action parameters, which can be an associative array, a
      #   JSON-string or an object with `#read` method
      # @param [NilClass, Hash] rest
      #   associative array of additional action parameters or `nil`, if
      #   there are no additional parameters
      # @return [Hash]
      #   resulting associative array
      def self.index_shops(params, rest)
        IndexShops.new(params, rest).index
      end
    end
  end
end
