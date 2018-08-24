# frozen_string_literal: true

module Shakuro
  need 'actions/base/action'

  module Actions
    module Shops
      # Class of actions which mark book copies in a shop as sold
      class SellBookCopies < Base::Action
        require_relative 'sell_book_copies/errors'
        require_relative 'sell_book_copies/params_schema'

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
        #   if one or more of book copies has already been sold
        def sell
          check_shop_book_copy_ids!
          Sequel::Model.db.transaction(savepoint: true) do
            updated_ids =
              Models::BookCopy
              .where(id: book_copy_ids_dataset)
              .returning(:id)
              .update(sold_at: Time.now)
              .map { |hash| hash[:id] }
            check_updated_ids!(updated_ids)
          end
        end

        private

        # Returns value of `id` parameter
        # @return [Object]
        #   value of `id` parameter
        def id
          params[:id]
        end

        # Returns value of `book_copy_ids` parameter
        # @return [Array]
        #   value of `book_copy_ids` parameter
        def book_copy_ids
          params[:book_copy_ids]
        end

        # Returns record of shop
        # @return [Shakuro::Models::Shop]
        #   record of shop
        # @raise [Sequel::NoMatchingRow]
        #   if the record can't be found by `id` parameter
        def shop
          @shop ||= Models::Shop.with_pk!(id)
        end

        # Returns subarray of {book_copy_ids} of those identifiers, book copies
        # of which are in the shop
        # @return [Array<Integer>]
        #   resulting array
        def shop_book_copy_ids
          Models::BookCopy
            .where(id: book_copy_ids, shop_id: shop.id)
            .select_map(:id)
        end

        # Checks if there are identifiers of book copies in {book_copy_ids}
        # which aren't in the shop
        # @raise [SellBookCopies::Errors::BookCopies::NotFound]
        #   if one or more of book copies isn't found in the shop
        def check_shop_book_copy_ids!
          not_found = book_copy_ids.map(&:to_i) - shop_book_copy_ids
          return if not_found.empty?
          raise Errors::BookCopies::NotFound.new(shop, not_found)
        end

        # Returns Sequel dataset of identifiers of book copies which aren't
        # sold yet in the shop
        # @return [Sequel::Dataset]
        #   resulting Sequel dataset
        def book_copy_ids_dataset
          Models::BookCopy
            .select(:id)
            .for_update
            .where(id: book_copy_ids, shop_id: shop.id, sold_at: nil)
        end

        # Checks if there are identifiers of book copies in {book_copy_ids}
        # which have already been sold
        # @param [Array<Integer>] updated_ids
        #   array of identifiers of updated records of book copies
        # @raise [SellBookCopies::Errors::BookCopies::Sold]
        #   if one or more of book copies has already been sold
        def check_updated_ids!(updated_ids)
          sold = book_copy_ids.map(&:to_i) - updated_ids
          raise Errors::BookCopies::Sold.new(shop, sold) unless sold.empty?
        end
      end
    end
  end
end
