Sequel.migration do
  change do
    alter_table :users do
      add_column :external_provider, :text

      add_unique_constraint :username
    end
  end
end
