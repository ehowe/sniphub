Sequel.migration do
  change do
    alter_table :users do
      rename_column :email, :username
    end
  end
end
