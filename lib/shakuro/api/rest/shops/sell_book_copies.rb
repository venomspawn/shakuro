# frozen_string_literal: true

module Shakuro
  module API
    module REST
      # Provides definitions of REST API methods which operate by information
      # of shops
      module Shops
        # Provides definition of REST API method which marks book copies of a
        # shop as sold
        module SellBookCopies
          # Registers REST API method in REST API controller
          # @param [Shakuro::API::REST::Controller] controller
          #   REST API controller
          def self.registered(controller)
            # Marks book copies of a shop as sold
            # @param [Hash] params
            #   associative array with structure described in
            #   {Actions::Shops::SellBookCopies::PARAMS_SCHEMA JSON-schema}
            # @return [Status]
            #   204
            controller.post '/shops/:id/sold_book_copies' do |id|
              Actions::Shops.sell_book_copies(request.body, id: id)
              status :no_content
            end
          end
        end

        Controller.register SellBookCopies
      end
    end
  end
end
