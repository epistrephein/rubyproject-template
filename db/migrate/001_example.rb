# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:examples) do
      primary_key :id
      String :name, null: false
    end
  end

  down do
    drop_table(:examples)
  end
end
