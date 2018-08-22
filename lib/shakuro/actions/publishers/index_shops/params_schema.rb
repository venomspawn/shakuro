# frozen_string_literal: true

module Shakuro
  module Actions
    module Publishers
      class IndexShops
        # JSON-schema of action parameters
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: %i[integer string],
              pattern: /\A[0-9]+\z/
            }
          },
          required: %i[
            id
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
