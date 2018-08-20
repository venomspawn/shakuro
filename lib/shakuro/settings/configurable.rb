# frozen_string_literal: true

require_relative 'class_factory'

module Shakuro
  module Settings
    # Provides methods to return settings
    module Configurable
      # Returns settings
      # @return [Settings]
      #   settings
      def settings
        @settings ||= settings_class.new
      end

      # Yields settings
      # @yieldparam [Settings]
      #   settings
      def configure
        yield settings
      end

      private

      # Adds arguments to array of settings names and returns the array
      # @param [Array] args
      #   list of settings names
      # @return [Array]
      #   whole list of settings names
      def settings_names(*args)
        @settings_names ||= []
        @settings_names.concat(args)
      end

      # Returns class of settings
      # @return [Class]
      #   class of settings
      def settings_class
        @settings_class ||= ClassFactory.create(*settings_names)
      end
    end
  end
end
