# frozen_string_literal: true

require 'logger'

require_relative 'log/prefix'

module Shakuro
  # Namespace auxiliary modules
  module Helpers
    # Provides logging methods
    module Log
      private

      # Returns logger
      # @return [Logger]
      #   logger
      def logger
        Shakuro.logger
      end

      # Yields a message and logs it with provided log level and context
      # @param [Integer] level
      #   log level
      # @param [Binding] context
      #   context
      # @yield [String]
      #   message
      def log_with_level(level, context = nil)
        return unless logger.is_a?(Logger)

        logger.log(level) do
          prefix = Prefix.new(context).prefix
          message = adjusted_message(yield)
          [prefix, message].find_all(&:present?).join(' ')
        end

        nil
      end

      # Yields a message and logs it with DEBUG log level and provided context
      # @param [Binding] context
      #   context
      # @yield [String]
      #   message
      def log_debug(context = nil, &block)
        log_with_level(Logger::DEBUG, context, &block)
      end

      # Yields a message and logs it with INFO log level and provided context
      # @param [Binding] context
      #   context
      # @yield [String]
      #   message
      def log_info(context = nil, &block)
        log_with_level(Logger::INFO, context, &block)
      end

      # Yields a message and logs it with WARN log level and provided context
      # @param [Binding] context
      #   context
      # @yield [String]
      #   message
      def log_warn(context = nil, &block)
        log_with_level(Logger::WARN, context, &block)
      end

      # Yields a message and logs it with ERROR log level and provided context
      # @param [Binding] context
      #   context
      # @yield [String]
      #   message
      def log_error(context = nil, &block)
        log_with_level(Logger::ERROR, context, &block)
      end

      # Yields a message and logs it with UNKNOWN log level and provided
      # context
      # @param [Binding] context
      #   context
      # @yield [String]
      #   message
      def log_unknown(context = nil, &block)
        log_with_level(Logger::UNKNOWN, context, &block)
      end

      # Returns correct string in UTF-8 encoding made from the argument
      # @param [#to_s] obj
      #   argument
      # @return [String]
      #   resulting string
      def repaired_string(obj)
        str = obj.to_s
        return str if str.encoding == Encoding::UTF_8 && str.valid_encoding?
        str = str.dup if str.frozen?
        str.force_encoding(Encoding::UTF_8)
        return str if str.valid_encoding?
        str.force_encoding(Encoding::ASCII_8BIT)
        str.encode(Encoding::UTF_8, undef: :replace, invalid: :replace)
      end

      # Returns correct string in UTF-8 encoding made from the argument with
      # squished blank characters
      # @param [#to_s] message
      #   argument
      # @return [String]
      #   resulting string
      def adjusted_message(message)
        repaired_string(message).squish
      end
    end
  end
end
