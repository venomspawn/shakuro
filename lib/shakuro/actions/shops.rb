# frozen_string_literal: true

module Shakuro
  module Actions
    # Provides functions to access actions on shops
    module Shops
      require_relative 'shops/sell_book_copies'

      # Marks books copies as sold in a shop
      # @param [Object] params
      #   object of action parameters, which can be an associative array, a
      #   JSON-string or an object with `#read` method
      # @param [NilClass, Hash] rest
      #   associative array of additional action parameters or `nil`, if
      #   there are no additional parameters
      # @raise [SellBookCopies::Errors::BookCopies::NotFound]
      #   if one or more of book copies isn't found in the shop
      # @raise [SellBookCopies::Errors::BookCopies::Sold]
      #   if one or more of book copies have already been sold
      def self.sell_book_copies(params, rest = nil)
        SellBookCopies.new(params, rest).sell
      end
    end
  end
end
