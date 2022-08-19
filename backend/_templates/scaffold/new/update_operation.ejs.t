---
to: lib/operations/<%= h.inflection.pluralize(name) %>/update.rb
---
require_relative "../result"
require_relative "../../validators/<%= h.inflection.pluralize(name) %>/update"

class Sniphub
  module Operations
    module <%= h.inflection.capitalize(h.inflection.pluralize(name)) %>
      module Update
        module_function

        def call(params = {})
          result = Sniphub::Validators::<%= h.inflection.pluralize(h.inflection.capitalize(name)) %>::Update.validate(params)

          # Add defaults to hash
          update_params = {}.merge(result.to_h)

          unless result.success?
            return Sniphub::Operations::Result.new(:error, result.errors)
          end

          updated_<%= name %> = Sniphub::DB.relations[:<%= h.inflection.pluralize(name) %>].changeset(:update, update_params).commit

          Sniphub::Operations::Result.new(:ok, updated_<%= name %>)
        end
      end
    end
  end
end
