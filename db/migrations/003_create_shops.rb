# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:shops) do
      primary_key :id

      column :name, :text, null: false
    end
  end
end
