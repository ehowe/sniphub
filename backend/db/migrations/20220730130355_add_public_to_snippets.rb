Sequel.migration do
  change do
    alter_table :snippets do
      add_column :public, :boolean, null: false, default: true
    end
  end
end
