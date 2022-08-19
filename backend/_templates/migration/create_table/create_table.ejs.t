---
sh: "cat > <%= cwd %>/db/migrations/`date +'%Y%m%d%H%M%S'`_create_<%= h.inflection.pluralize(name) %>.rb"
---
Sequel.migration do
  change do
    create_table :<%= h.inflection.pluralize(name) %> do
      uuid :id, primary_key: true
      <%_ [].concat(attr).map(attribute => { _%>
        <%_ [attrName, type] = attribute.split(':') _%>
        <%_ columnType = type == 'string' ? 'text' : columnType _%>
      column :<%= attrName %>, :<%= columnType %>, default: "", null: false
      <%_ }) _%>
    end
  end
end
