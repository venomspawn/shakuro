# frozen_string_literal: true

module Shakuro
  need 'actions/publishers/index_shops/result_schema'

  module Actions
    module Publishers
      class IndexShops
        # Provides methods used in tests of containing class
        module SpecHelper
          # Returns JSON-schema of action result
          # @return [Hash]
          #   JSON-schema of action result
          def schema
            RESULT_SCHEMA
          end

          # Returns amount of sold book copies for a shop with provided index
          SOLD = ->(i) { [2 - i, 0].max }

          # Returns amount of in stock book copies for a shop with provided
          # index
          IN_STOCK = ->(i) { [2 - i, 0].max }

          # Creates records of book copies and returns array of them
          # @param [Array<Shakuro::Models::Book>]
          #   array of records of books released by publisher
          # @param [Array<Shakuro::Models::Shop>]
          #   array of shop records
          # @return [Array<Shakuro::Models::BookCopy>]
          #   resulting array of records
          def create_book_copies(books, shops)
            shops.each_with_index.each_with_object([]) do |(shop, i), memo|
              books.each do |book|
                SOLD[i].times { memo << create_book_copy(book, shop) }
                IN_STOCK[i].times { memo << create_book_copy(book, shop, nil) }
              end
            end
          end

          # Creates and returns record of a book copy
          # @param [Shakuro::Models::Book] book
          #   book record
          # @param [Shakuro::Models::Shop] shop
          #   shop record
          # @param [NilClass, Time] sold_at
          #   date and time when the copy was sold, or `nil` if the copy isn't
          #   sold yet
          # @return [Shakuro::Models::BookCopy]
          #   resulting record
          def create_book_copy(book, shop, sold_at = Time.now)
            traits = { book_id: book.id, shop_id: shop.id, sold_at: sold_at }
            FactoryBot.create(:book_copy, traits)
          end
        end
      end
    end
  end
end
