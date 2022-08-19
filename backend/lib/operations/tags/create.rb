require_relative "../result"
require_relative "../../validators/tags/create"

class Sniphub
  module Operations
    module Tags
      module Create
        module_function

        def call(params = {})
          result = Sniphub::Validators::Tags::Create.validate(params)

          unless result.success?
            return Sniphub::Operations::Result.new(:error, result.errors)
          end

          new_tag = Sniphub::Tag.create(result.to_h)

          Sniphub::Operations::Result.new(:ok, new_tag)
        end
      end
    end
  end
end
