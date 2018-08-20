# frozen_string_literal: true

require_relative 'mixin'

module Shakuro
  module Settings
    # Provides function to create classes of settings
    module ClassFactory
      # Creates and returns new class of settings with provided names
      # @param [Array<#to_s>] names
      #   array of settings names
      # @return [Class]
      #   class of settings
      def self.create(*names)
        names.map! { |name| name.is_a?(Symbol) ? name : name.to_s.to_sym }
        Struct.new(*names) { include Mixin }
      end
    end
  end
end
