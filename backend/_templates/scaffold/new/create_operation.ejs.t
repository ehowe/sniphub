---
to: lib/operations/<%= h.inflection.pluralize(name) %>/create.rb
---
require_relative "../result"
require_relative "../../validators/<%= h.inflection.pluralize(name) %>/create"

class Sniphub
  module Operations
    module <%= h.inflection.capitalize(h.inflection.pluralize(name)) %>
      module Create
        module_function

        def call(params = {})
          result = Sniphub::Validators::<%= h.inflection.pluralize(h.inflection.capitalize(name)) %>::Create.validate(params)

          # Add defaults to hash
          create_params = {}.merge(result.to_h)

          unless result.success?
            return Sniphub::Operations::Result.new(:error, result.errors)
          end

          new_<%= name %> = Sniphub::DB.relations[:<%= h.inflection.pluralize(name) %>].changeset(:create, create_params).commit

          Sniphub::Operations::Result.new(:ok, new_<%= name %>)
        end
      end
    end
  end
end
