Sequel.migration do
  change do
    alter_table :snippets do
      add_column :visible_to_groups, null: false, default: true
    end
  end
end
