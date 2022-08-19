---
sh: "cat > <%= cwd %>/db/migrations/`date +'%Y%m%d%H%M%S'`_<%= name %>.rb"
---
Sequel.migration do
  change do
  end
end
