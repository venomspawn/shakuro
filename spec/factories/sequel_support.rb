# frozen_string_literal: true

# Sequel support in FactoryBot

FactoryBot.define do
  to_create(&:save)
end
