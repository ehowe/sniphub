Sequel.migration do
  change do
    [:snippets, :tags].each do |table|
      alter_table table do
        add_column :created_at, :timestamptz
        add_column :updated_at, :timestamptz
      end

      from(table).update(created_at: Time.now, updated_at: Time.now)

      alter_table table do
        set_column_not_null :created_at
        set_column_not_null :updated_at
      end
    end
  end
end
