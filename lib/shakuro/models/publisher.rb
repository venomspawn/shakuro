# frozen_string_literal: true

module Shakuro
  # Namespace of models
  module Models
    # Model of publisher
    # @!attribute id
    #   Identifier
    #   @return [Integer]
    #     identifier
    # @!attribute name
    #   Name
    #   @return [String]
    #     name
    class Publisher < Sequel::Model
    end
  end
end
