# frozen_string_literal: true

module Shakuro
  module Models
    # Model of book
    # @!attribute id
    #   Identifier
    #   @return [Integer]
    #     identifier
    # @!attribute title
    #   Title
    #   @return [String]
    #     title
    # @!attribute publisher_id
    #   Identifier of publisher record
    #   @return [Integer]
    #     identifier of publisher record
    class Book < Sequel::Model
    end
  end
end
