# frozen_string_literal: true

require 'rack/common_logger'

module Shakuro
  module API
    module REST
      # Class of custom Rack-logger
      class Logger < Rack::CommonLogger
        # Initializes instance
        # @param [#call] app
        #   Rack-application
        def initialize(app)
          super(app, Shakuro.logger)
        end

        # Array of method names with muted Rack-logging
        BLACK_LIST = %w[/version].freeze

        # Gets called by Rack
        # @param [Hash] env
        #   associative array of Rack-parameters
        def call(env)
          black_listed?(env) ? @app.call(env) : super
        end

        # Returns if Rack-logging should be muted for the REST API method
        # @param [Hash] env
        #   associative array of Rack-parameters
        # @return [Boolean]
        #   if Rack-logging should be muted for the REST API method
        def black_listed?(env)
          BLACK_LIST.include?(env['PATH_INFO'])
        end
      end
    end
  end
end
