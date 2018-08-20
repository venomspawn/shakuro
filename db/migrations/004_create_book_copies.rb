# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:book_copies) do
      primary_key :id

      column :sold_at, :timestamp, index: true

      foreign_key :book_id, :books,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade

      foreign_key :shop_id, :shops,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade
    end
  end
end
