require_relative "../result"
require_relative "../../validators/snippets/create"

class Sniphub
  module Operations
    module Snippets
      module Create
        module_function

        def call(params: {}, user:)
          result = Sniphub::Validators::Snippets::Create.validate(params)

          unless result.success?
            return Sniphub::Operations::Result.new(:error, result.errors)
          end

          new_snippet = Sniphub::Snippet.create(result.to_h.merge(user_id: user.id))

          Result.new(:ok, new_snippet)
        end
      end
    end
  end
end
