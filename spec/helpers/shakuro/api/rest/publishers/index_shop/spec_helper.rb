# frozen_string_literal: true

module Shakuro
  need 'actions/publishers/index_shops/result_schema'

  module API
    module REST
      module Publishers
        module IndexShops
          # Provides methods used in tests of REST API method defined in
          # containing module
          module SpecHelper
            # Returns JSON-schema of REST API method result
            # @return [Hash]
            #   JSON-schema of of REST API method result
            def schema
              Actions::Publishers::IndexShops::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
