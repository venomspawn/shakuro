# frozen_string_literal: true

FactoryBot.define do
  factory :shop, class: Shakuro::Models::Shop do
    name { create(:string) }
  end
end
