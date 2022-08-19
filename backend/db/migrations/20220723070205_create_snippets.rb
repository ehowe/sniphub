Sequel.migration do
  change do
    create_table :snippets do
      uuid :id, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      column :language, :text, default: "", null: false
      column :content, :text, default: "", null: false
      column :name, :text, default: "", null: false
    end
  end
end
