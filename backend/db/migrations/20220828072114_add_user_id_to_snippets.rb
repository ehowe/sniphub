Sequel.migration do
  change do
    alter_table :snippets do
      add_foreign_key :user_id, :users, on_delete: :cascade, null: false, type: :uuid
    end
  end
end
