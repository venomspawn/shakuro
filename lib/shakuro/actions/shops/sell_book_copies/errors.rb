# frozen_string_literal: true

module Shakuro
  module Actions
    module Shops
      class SellBookCopies
        # Namespace of modules with error classes used by containing class
        module Errors
          # Provides classes of errors associated with operations on book
          # copies
          module BookCopies
            # Class of error used to signal that one or more of book copies
            # isn't found in a shop
            class NotFound < RuntimeError
              # Initializes instance
              # @param [Shakuro::Models::Shop] shop
              #   record of the shop
              # @param [Array<Integer>] not_found
              #   array of identifiers of book copies which aren't found in the
              #   shop
              def initialize(shop, not_found)
                super(<<-MESSAGE.squish)
                  Book copies with the following record identifiers aren't
                  found in the shop with record identifer `#{shop.id}`:
                  `#{not_found.join('`, `')}`
                MESSAGE
              end
            end

            # Class of error used to signal that one or more of book copy
            # has already been sold in the shop
            class Sold < RuntimeError
              # Initializes instance
              # @param [Shakuro::Models::Shop] shop
              #   record of the shop
              # @param [Array<Integer>] sold
              #   array of identifiers of book copies which have already been
              #   sold
              def initialize(shop, sold)
                super(<<-MESSAGE.squish)
                  Book copies with the following record identifiers have
                  already been sold in the shop with record identifer
                  `#{shop.id}`: `#{sold.join('`, `')}`
                MESSAGE
              end
            end
          end
        end
      end
    end
  end
end
