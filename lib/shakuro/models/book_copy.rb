# frozen_string_literal: true

module Shakuro
  module Models
    # Model of book copy in a shop
    # @!attribute id
    #   Identifier
    #   @return [Integer]
    #     identifier
    # @!attribute sold_at
    #   Date and time when the copy was sold, or `nil` if the copy isn't sold
    #   yet
    #   @return [NilClass, Time]
    #     date and time when the copy was sold, or `nil` if the copy isn't sold
    #     yet
    # @!attribute book_id
    #   Identifier of book record
    #   @return [Integer]
    #     identifier of book record
    # @!attribute shop_id
    #   Identifier of shop record
    #   @return [Integer]
    #     identifier of shop record
    class BookCopy < Sequel::Model
    end
  end
end
