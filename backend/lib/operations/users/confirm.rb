require_relative "../result"
require_relative "../../validators/users/confirm"

class Sniphub
  module Operations
    module Users
      module Confirm
        module_function

        def call(params)
          validator = Sniphub::Validators::Users::Confirm.validate(params)

          unless validator.success?
            return Sniphub::Operations::Result.new(:error, validator.errors)
          end

          user = validator.user

          user.update(confirmation_token: nil)

          Result.new(:ok, user)
        end
      end
    end
  end
end
