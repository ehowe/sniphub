require_relative "../result"
require_relative "../../validators/users/register"

class Sniphub
  module Operations
    module Users
      module Register
        module_function

        def call(params)
          validator = Sniphub::Validators::Users::Register.validate(params)

          unless validator.success?
            return Sniphub::Operations::Result.new(:error, validator.errors)
          end

          user = Sniphub::User.create(validator.to_h)

          if ENV.fetch("EMAIL_ENABLED")
            # TODO: Implement mailer
          else
            p ENV
            Sniphub::Logger.info("Confirmation link: /users/confirm/#{user.id}?token=#{user.confirmation_token}")
          end

          Result.new(:ok, user)
        end
      end
    end
  end
end
