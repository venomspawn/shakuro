# frozen_string_literal: true

module Shakuro
  module Actions
    module Publishers
      class IndexShops
        # JSON-schema of action invocation's result
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            shops: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: {
                    type: :integer
                  },
                  name: {
                    type: :string
                  },
                  books_sold_count: {
                    type: :integer,
                    minimum: 0
                  },
                  books_in_stock: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: {
                          type: :integer
                        },
                        title: {
                          type: :string
                        },
                        copies_in_stock: {
                          type: :integer,
                          minimum: 1
                        }
                      },
                      required: %i[
                        id
                        title
                        copies_in_stock
                      ],
                      additionalProperties: false
                    },
                    minItems: 1
                  }
                },
                required: %i[
                  id
                  name
                  books_sold_count
                  books_in_stock
                ],
                additionalProperties: false
              }
            }
          },
          required: %i[
            shops
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
