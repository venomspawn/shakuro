# frozen_string_literal: true

require 'sinatra/base'

module Shakuro
  # Namespace for service API
  module API
    # Namespace for service REST API
    module REST
      # Class of REST API controller
      class Controller < Sinatra::Base
        # Default content type of response bodies
        CONTENT_TYPE = 'application/json; charset=utf-8'

        before { content_type CONTENT_TYPE }
      end
    end
  end
end
