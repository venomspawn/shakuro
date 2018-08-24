# frozen_string_literal: true

module Shakuro
  module Actions
    module Shops
      class SellBookCopies
        # JSON-schema of action parameters
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: %i[integer string],
              pattern: /\A[0-9]+\z/
            },
            book_copy_ids: {
              type: :array,
              items: {
                type: %i[integer string],
                pattern: /\A[0-9]+\z/
              }
            }
          },
          required: %i[
            id
            book_copy_ids
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
