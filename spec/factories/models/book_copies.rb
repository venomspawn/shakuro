# frozen_string_literal: true

FactoryBot.define do
  factory :book_copy, class: Shakuro::Models::BookCopy do
    sold_at { Time.now }
    book_id { create(:book).id }
    shop_id { create(:shop).id }
  end
end
