Sequel.migration do
  change do
    alter_table :users do
      add_column :confirmation_token, :text
    end
  end
end
