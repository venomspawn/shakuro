# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:publishers) do
      primary_key :id

      column :name, :text, null: false
    end
  end
end
