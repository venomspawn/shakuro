# frozen_string_literal: true

FactoryBot.define do
  factory :book, class: Shakuro::Models::Book do
    title        { create(:string) }
    publisher_id { create(:publisher).id }
  end
end
