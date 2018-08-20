# frozen_string_literal: true

module Shakuro
  need 'version'

  module API
    module REST
      # Provides definitions of REST API methods for service version
      module Version
        # Provides definition of REST API method which returns information of
        # the service version
        module Show
          # Associative array with information of the service version
          CONTENT = {
            version:  Shakuro::VERSION,
            hostname: `hostname`.strip
          }.freeze

          # Body of the method's response
          BODY = Oj.dump(CONTENT).freeze

          # Registers REST API method in REST API controller
          # @param [Shakuro::API::REST::Controller] controller
          #   REST API controller
          def self.registered(controller)
            # Returns information of the service version
            # @return [Hash]
            #   associative array with information of the service version
            # @return [Status]
            #   200
            controller.get '/version' do
              status :ok
              body BODY
            end
          end
        end

        Controller.register Show
      end
    end
  end
end
