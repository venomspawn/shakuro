# frozen_string_literal: true

require 'json-schema'

module Shakuro
  need 'helpers/log'

  module API
    module REST
      # Provides defintions of exception handlers
      module Errors
        # Provides auxiliary methods
        module Helpers
          include Shakuro::Helpers::Log

          # Returns an object with information about exception
          # @return [Exception]
          #   object with information about exception
          def error
            env['sinatra.error']
          end

          # Name of the service in upcase
          NAME = Shakuro.name.upcase.freeze

          # Logs error
          def log_regular_error
            log_error { <<~LOG }
              #{NAME} ERROR #{error.class} WITH MESSAGE #{error.message}
            LOG
          end
        end

        # Maps exception classes to HTTP codes
        ERRORS_MAP = {
          ArgumentError                     => 422,
          JSON::Schema::ValidationError     => 422,
          Oj::ParseError                    => 422,
          RuntimeError                      => 422,
          Sequel::DatabaseError             => 422,
          Sequel::Error                     => 422,
          Sequel::NoMatchingRow             => 404,
          Sequel::InvalidValue              => 422,
          Sequel::UniqueConstraintViolation => 422
        }.freeze

        # Registers exception handler
        # @param [Shakuro::API::REST::Controller] controller
        #   REST API controller
        # @param [Class] error_class
        #   class of exception
        # @param [Integer] error_code
        #   HTTP code
        def self.define_error_handler(controller, error_class, error_code)
          controller.error error_class do
            log_regular_error unless error_code == 404
            status error_code
            content = { error: error_class, message: error.message }
            body Oj.dump(content)
          end
        end

        # Registers exception handlers accordingly with {ERRORS_MAP}
        # @param [Shakuro::API::REST::Controller] controller
        #   REST API controller
        def self.define_error_handlers(controller)
          ERRORS_MAP.each do |error_class, error_code|
            define_error_handler(controller, error_class, error_code)
          end
        end

        # Registers exception handler for errors which are absent in
        # {ERRORS_MAP}
        # @param [Shakuro::API::REST::Controller] controller
        #   REST API controller
        def self.define_500_handler(controller)
          controller.error 500 do
            log_regular_error
            status 500
            content = { error: error.class, message: error.message }
            body Oj.dump(content)
          end
        end

        # Registers exception handlers
        # @param [Shakuro::API::REST::Controller] controller
        #   REST API controller
        def self.registered(controller)
          controller.helpers Helpers
          define_error_handlers(controller)
          define_500_handler(controller)
        end
      end

      Controller.register Errors
    end
  end
end
