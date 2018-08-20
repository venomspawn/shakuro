# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:books) do
      primary_key :id

      column :title, :text, null: false

      foreign_key :publisher_id, :publishers,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade
    end
  end
end
