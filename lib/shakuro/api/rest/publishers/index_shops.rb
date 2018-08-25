# frozen_string_literal: true

module Shakuro
  module API
    module REST
      # Provides definitions of REST API methods which operate by information
      # of publishers
      module Publishers
        # Provides definition of REST API method which returns information of
        # shops selling at least one copy of a book released by a publisher
        module IndexShops
          # Registers REST API method in REST API controller
          # @param [Shakuro::API::REST::Controller] controller
          #   REST API controller
          def self.registered(controller)
            # Returns information of shops selling at least one copy of a book
            # released by a publisher
            # @return [Hash]
            #   associative array with structure described in
            #   {Actions::Publishers::IndexShops::RESULT_SCHEMA JSON-schema}
            # @return [Status]
            #   200
            controller.get '/publishers/:id/shops' do |id|
              content = Actions::Publishers.index_shops(id: id)
              status :ok
              body Oj.dump(content)
            end
          end
        end

        Controller.register IndexShops
      end
    end
  end
end
