require_relative "../result"
require_relative "../../validators/snippets/update"

class Sniphub
  module Operations
    module Snippets
      module Update
        module_function

        def call(snippet, params = {})
          validator = Sniphub::Validators::Snippets::Update.validate(params)

          unless validator.success?
            return Sniphub::Operations::Result.new(:error, result.errors)
          end

          updated_snippet = snippet.update(validator.to_h)

          Result.new(:ok, updated_snippet)
        end
      end
    end
  end
end
