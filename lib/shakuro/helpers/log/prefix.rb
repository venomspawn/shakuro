# frozen_string_literal: true

module Shakuro
  module Helpers
    module Log
      # Class of objects which form prefixes in log messages
      class Prefix
        # Context
        # @return [Binding]
        #   context
        attr_reader :context

        # Initializes instance
        # @param [Binding] context
        #   context
        def initialize(context)
          @context = context
        end

        # Returns string with log message prefix formed by tags returned by
        # {eval_strings} and additional tags
        # @param [Array<#to_s>] tags
        #   array of additional tags
        # @return [String]
        #   string with the prefix
        def prefix(*tags)
          tags
            .concat(eval_strings)
            .find_all(&:present?)
            .map { |tag| "[#{tag}]" }
            .join(' ')
        end

        private

        # Array of expressions which are evaluating in provided context
        EVAL_STRINGS = ['self.class', '__method__', '__LINE__'].freeze

        # Returns array of tags extracted from provided context
        # @return [Array]
        #   array of tags
        def eval_strings
          return [] unless context.is_a?(Binding)
          EVAL_STRINGS.map(&context.method(:eval))
        end
      end
    end
  end
end
