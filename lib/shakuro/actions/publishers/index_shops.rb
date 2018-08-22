# frozen_string_literal: true

module Shakuro
  need 'actions/base/action'

  module Actions
    module Publishers
      # Class of actions which extract information about shops selling book
      # copies of publishers
      class IndexShops < Base::Action
        require_relative 'index_shops/params_schema'

        # Returns associative array with information about shops selling at
        # least one book copy of the publisher
        # @return [Hash]
        #   resulting associative array
        def index
          { shops: shops_with_books_in_stock }
        end

        private

        # Returns value of `id` parameter
        # @return [Object]
        #   value of `id` parameter
        def id
          params[:id]
        end

        # Returns record of publisher
        # @return [Shakuro::Models::Publisher]
        #   record of publisher
        # @raise [Sequel::NoMatchingRow]
        #   if the record can't be found by `id` parameter
        def publisher
          @publisher ||= Models::Publisher.with_pk!(id)
        end

        # Returns array with information about books sold and in stock in shops
        # @return [Array<Hash>]
        #   resulting array
        def shops_with_books_in_stock
          shops.map do |shop|
            shop.dup.tap do |copy|
              id = copy[:id]
              copy[:books_in_stock] = books_in_stock[id]
            end
          end
        end

        # Returns array with information about books sold in shops
        # @return [Array<Hash>]
        #   resulting array
        def shops
          @shops ||= shops_dataset.to_a
        end

        # Returns array of shop identifiers extracted from result of {shops}
        # method
        # @return [Array<Integer>]
        #   resulting array
        def shop_ids
          shops.map { |hash| hash[:id] }
        end

        # Full identifier `shops.id`
        SHOPS_ID = :id.qualify(:shops)

        # Alias `shop_id` for {SHOPS_ID}
        SHOP_ID = SHOPS_ID.as(:shop_id)

        # Full identifer `book_copies.sold_at`
        BOOK_COPIES_SOLD_AT = :sold_at.qualify(:book_copies)

        # Expression to count rows with not null values of `sold_at` field
        BOOK_COPIES_SOLD_AT_COUNT = :count.sql_function(BOOK_COPIES_SOLD_AT)

        # Alias `books_sold_count` for {BOOK_COPIES_SOLD_AT_COUNT}
        BOOKS_SOLD_COUNT = BOOK_COPIES_SOLD_AT_COUNT.as(:books_sold_count)

        # Expression to select complete rows
        TOTAL = '*'.lit

        # Expression to count all rows
        TOTAL_COUNT = :count.sql_function(TOTAL)

        # Expression to count rows with null values of `sold_at` field
        BOOK_COPIES_SELLING_COUNT = TOTAL_COUNT - BOOK_COPIES_SOLD_AT_COUNT

        # Alias `books_selling_count` for {BOOKS_COPIES_SELLING_COUNT}
        BOOKS_SELLING_COUNT =
          BOOK_COPIES_SELLING_COUNT.as(:books_selling_count)

        # Sequel dataset with shop identifiers and amounts of book copies sold
        # and selling in the shops
        SHOP_BOOKS_DATASET =
          Models::Shop
          .dataset
          .join(:book_copies, shop_id: :id)
          .join(:books, id: :book_id)
          .select(SHOP_ID, BOOKS_SOLD_COUNT, BOOKS_SELLING_COUNT)
          .group_by(SHOPS_ID)

        # Full identifier `books.publisher_id`
        BOOKS_PUBLISHER_ID = :publisher_id.qualify(:books)

        # Returns Sequel dataset with shop identifiers and amounts of book
        # copies sold and selling in the shops, released by publisher
        # @return [Sequel::Dataset]
        #   resulting Sequel dataset
        def shop_books_dataset
          SHOP_BOOKS_DATASET
            .where(BOOKS_PUBLISHER_ID => publisher.id)
            .as(:shop_books)
        end

        # Full identifier `shops.name`
        SHOPS_NAME = :name.qualify(:shops)

        # Full identifier `shop_books.books_sold_count`
        SHOP_BOOKS_BOOKS_SOLD_COUNT = :books_sold_count.qualify(:shop_books)

        # Expression to order rows by `shop_books.books_sold_count` descending
        SHOP_BOOKS_BOOKS_SOLD_COUNT_DESC = SHOP_BOOKS_BOOKS_SOLD_COUNT.desc

        # Full identifier `shop_books.books_selling_count`
        SHOP_BOOKS_BOOKS_SELLING_COUNT =
          :books_selling_count.qualify(:shop_books)

        # Full identifer `shop_books.shop_id`
        SHOP_BOOKS_SHOP_ID = :shop_id.qualify(:shop_books)

        # Returns Sequel dataset with shop identifiers, shop names and amounts
        # of sold book copies released by publisher. Selects only the shops
        # with at least one book of the publisher currently selling.
        # @return [Sequel::Dataset]
        #   resulting Sequel dataset
        def shops_dataset
          # rubocop: disable Style/NumericPredicate
          Models::Shop
            .dataset
            .join(shop_books_dataset, SHOPS_ID => SHOP_BOOKS_SHOP_ID)
            .select(SHOPS_ID, SHOPS_NAME, SHOP_BOOKS_BOOKS_SOLD_COUNT)
            .where { SHOP_BOOKS_BOOKS_SELLING_COUNT > 0 }
            .order(SHOP_BOOKS_BOOKS_SOLD_COUNT_DESC)
            .naked
          # rubocop: enable Style/NumericPredicate
        end

        # Returns associative array with information about books of publisher
        # in stock in shops. Keys of the associative array are identifiers of
        # shops, values are arrays with the information.
        # @return [Hash{Integer => Array<Hash>}]
        #   resulting associative array
        def books_in_stock
          @books_in_stock ||=
            books_in_stock_dataset.each_with_object({}) do |book, memo|
              shop_id = book.delete(:shop_id)
              memo[shop_id] ||= []
              memo[shop_id] << book
            end
        end

        # Full identifier `books.id`
        BOOKS_ID = :id.qualify(:books)

        # Full identifier `books.title`
        BOOKS_TITLE = :title.qualify(:books)

        # Alias `copies_in_stock` for {TOTAL_COUNT}
        COPIES_IN_STOCK = TOTAL_COUNT.as(:copies_in_stock)

        # Sequel dataset with shop identifiers, book identifiers, book titles
        # and amounts of the books in stock
        BOOKS_IN_STOCK_DATASET =
          Models::Shop
          .dataset
          .join(:book_copies, shop_id: :id)
          .join(:books, id: :book_id)
          .select(SHOP_ID, BOOKS_ID, BOOKS_TITLE, COPIES_IN_STOCK)
          .where(BOOK_COPIES_SOLD_AT => nil)
          .group_by(SHOPS_ID, BOOKS_ID)
          .naked

        # Returns Sequel dataset with shop identifiers, book identifiers, book
        # titles and amounts of the books in stock. Selects only books of
        # publisher and shops with identifiers specified by {shop_ids}.
        # @return [Sequel::Dataset]
        #   resulting Sequel dataset
        def books_in_stock_dataset
          BOOKS_IN_STOCK_DATASET
            .where(BOOKS_PUBLISHER_ID => publisher.id, SHOPS_ID => shop_ids)
        end
      end
    end
  end
end
