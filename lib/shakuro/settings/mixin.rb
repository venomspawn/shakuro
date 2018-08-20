# frozen_string_literal: true

module Shakuro
  # Namespace of modules which provide methods to work with settings
  module Settings
    # Provides methods to set individual settings
    module Mixin
      # Sets value of a setting
      # @param [#to_s] setting
      #   setting's name
      # @param [Object] value
      #   setting's value
      def set(setting, value)
        send("#{setting}=", value)
      end

      # Sets value of a setting to boolean `true`
      # @param [#to_s] setting
      #   setting's name
      def enable(setting)
        set(setting, true)
      end

      # Sets value of a setting to boolean `false`
      # @param [#to_s] setting
      #   setting's name
      def disable(setting)
        set(setting, false)
      end
    end
  end
end
