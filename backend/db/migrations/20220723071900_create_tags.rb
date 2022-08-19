Sequel.migration do
  change do
    create_table :tags do
      uuid :id, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      column :name, :text, default: "", null: false
    end

    create_table :snippets_tags do
      foreign_key :snippet_id, :snippets, on_delete: :cascade, type: :uuid
      foreign_key :tag_id,     :tags,     on_delete: :cascade, type: :uuid
    end
  end
end
