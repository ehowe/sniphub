---
to: lib/validators/<%= h.inflection.pluralize(name) %>/create.rb
---
require_relative "../validator"

class Sniphub
  module Validators
    module <%= h.inflection.pluralize(h.inflection.capitalize(name)) %>
      class Create < Sniphub::Validators::Validator
        <%_ [].concat(attr).map(attribute => { _%>
          <%_ [attrName, type] = attribute.split(':') _%>
        optional :<%= attrName %>, default: ""
        <%_ }) _%>
      end
    end
  end
end
