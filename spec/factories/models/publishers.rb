# frozen_string_literal: true

FactoryBot.define do
  factory :publisher, class: Shakuro::Models::Publisher do
    name { create(:string) }
  end
end
