Sequel.migration do
  change do
    create_table :users do
      uuid :id, primary_key: true, default: Sequel.function(:uuid_generate_v4)

      column :first_name,      :text , null: false
      column :last_name,       :text , null: false
      column :email,           :text , null: false
      column :password_digest, :text , null: false

      column :created_at, :timestamptz, null: false
      column :updated_at, :timestamptz, null: false
    end
  end
end
