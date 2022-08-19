require_relative "../result"
require_relative "../../validators/tags/update"

class Sniphub
  module Operations
    module Tags
      module Update
        module_function

        def call(tag, params = {})
          result = Sniphub::Validators::Tags::Update.validate(params)

          unless result.success?
            return Sniphub::Operations::Result.new(:error, result.errors)
          end

          updated_tag = tag.update(result.to_h)

          Sniphub::Operations::Result.new(:ok, updated_tag)
        end
      end
    end
  end
end
