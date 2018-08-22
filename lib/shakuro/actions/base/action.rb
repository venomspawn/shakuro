# frozen_string_literal: true

require_relative 'validator'

module Shakuro
  # Namespace of action classes
  module Actions
    # Namespace of base action classes
    module Base
      # Base action class, which provides check if action parameters correspond
      # to JSON-schema
      class Action
        extend Validator

        # Initializes instance
        # @param [Object] params
        #   object of action parameters, which can be an associative array, a
        #   JSON-string or an object with `#read` method
        # @param [NilClass, Hash] rest
        #   associative array of additional action parameters or `nil`, if
        #   there are no additional parameters
        # @raise [Oj::ParseError, EncodingError]
        #   if `params` argument is a string but not a JSON-string
        # @raise [JSON::Schema::ValidationError]
        #   if associative array of action parameters doesn't correspond to
        #   JSON-schema
        def initialize(params, rest = nil)
          @params = process_params(params, rest)
        end

        private

        # Associative array of action parameters
        # @return [Hash{Symbol => Object}]
        #   associative array of action parameters
        attr_reader :params

        # Extracts associative array of action parameters from the provided
        # arguments, checks if it corresponds to JSON-schema and returns it
        # @param [Object] params
        #   object of action parameters, which can be an associative array, a
        #   JSON-string or an object with `#read` method
        # @param [NilClass, Hash] rest
        #   associative array of additional action parameters or `nil`, if
        #   there are no additional parameters
        # @return [Hash{Symbol => Object}]
        #   associative array of action parameters
        # @raise [Oj::ParseError, EncodingError]
        #   if `params` argument is a string but not a JSON-string
        # @raise [JSON::Schema::ValidationError]
        #   if associative array of action parameters doesn't correspond to
        #   JSON-schema
        def process_params(params, rest)
          return process_hash(params, rest) if params.is_a?(Hash)
          return process_json(params, rest) if params.is_a?(String)
          return process_read(params, rest) if params.respond_to?(:read)
          # Raising JSON::Schema::ValidationError because `params` is obviously
          # something wrong
          validate!(params)
        end

        # Adds additional action parameters to the provided associative array
        # of action parameters if they're provided, checks if the result
        # corresponds to JSON-schema and returns it
        # @param [Hash{Symbol => Object}] hash
        #   associative array of action parameters
        # @param [NilClass, Hash] rest
        #   associative array of additional action parameters or `nil`, if
        #   there are no additional parameters
        # @return [Hash{Symbol => Object}]
        #   associative array of action parameters
        # @raise [JSON::Schema::ValidationError]
        #   if associative array of action parameters doesn't correspond to
        #   JSON-schema
        def process_hash(hash, rest)
          result = rest.nil? ? hash : hash.merge(rest)
          result.tap { validate!(stringify(result)) }
        end

        # Options for `Oj.load` function to recover data structure from
        # JSON-string with string keys of inner associative arrays
        STRING_KEYS = { symbol_keys: false }.freeze

        # Invokes the following steps.
        #
        # 1.  Recovers data structure from the provided JSON-string.
        # 2.  Checks if the data structure is an associative array.
        # 3.  Adds additional action parameters to the associative array.
        # 4.  Checks if the resulting associative array corresponds to
        #     JSON-schema.
        # 5.  Returns the associative array.
        # @param [String] json
        #   JSON-string
        # @param [NilClass, Hash] rest
        #   associative array of additional action parameters or `nil`, if
        #   there are no additional parameters
        # @return [Hash{Symbol => Object}]
        #   recovered associative array of action parameters
        # @raise [Oj::ParseError, EncodingError]
        #   if `json` argument is a string but not a JSON-string
        # @raise [JSON::Schema::ValidationError]
        #   if recovered associative array of action parameters doesn't
        #   correspond to JSON-schema
        def process_json(json, rest)
          # Recovering with string keys
          data = Oj.load(json, STRING_KEYS)
          # Raising JSON::Schema::ValidationError because recovered data
          # structure is obviously something wrong
          validate!(data) unless data.is_a?(Hash)
          data.update(stringify(rest)) unless rest.nil?
          validate!(data)
          # Recovering with symbol keys (it's faster than deep symbolizing)
          data = Oj.load(json)
          rest.nil? ? data : data.update(rest)
        end

        # Invokes the following steps.
        #
        # 1.  Invokes `#rewind` method of the provided object if it supports
        #     it.
        # 2.  Uses `#read` method of the provided object to get a string.
        # 3.  Calls {process_json} for the string and returns result.
        # @param [#read] stream
        #   stream-like object
        # @param [NilClass, Hash] rest
        #   associative array of additional action parameters or `nil`, if
        #   there are no additional parameters
        # @return [Hash{Symbol => Object}]
        #   recovered associative array of action parameters
        # @raise [Oj::ParseError, EncodingError]
        #   if `json` argument is a string but not a JSON-string
        # @raise [JSON::Schema::ValidationError]
        #   if recovered associative array of action parameters doesn't
        #   correspond to JSON-schema
        def process_read(stream, rest)
          stream.rewind if stream.respond_to?(:rewind)
          process_json(stream.read.to_s, rest)
        end

        # Checks if the provided data structure corresponds to JSON-schema.
        # Supposes that keys of inner associative arrays are strings.
        # @param [Object] data
        #   data structure
        # @raise [JSON::Schema::ValidationError]
        #   if the data structure doesn't correspond to JSON-schema
        def validate!(data)
          self.class.validate!(data)
        end

        # Returns a copy of the provided data structure with all keys of inner
        # associative array cast to strings
        # @param [Object] data
        #   data structure
        # @return [Object]
        #   resulting copy of the data structure
        def stringify(data)
          self.class.stringify(data)
        end
      end
    end
  end
end
