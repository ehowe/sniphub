require_relative "../validator"

require "securerandom"
require "uri"

class Sniphub
  module Validators
    module Users
      class Register < Sniphub::Validators::Validator
        required :first_name
        required :last_name
        required :username
        required :password
        required :password_confirmation

        def validate
          unless password == password_confirmation
            errors.push({ "password" => "password and confirmation are not equal" })
            errors.push({ "password_confirmation" => "password and confirmation are not equal" })
          end

          unless username.match(URI::MailTo::EMAIL_REGEXP)
            errors.push({ "username" => "must be an email address" })
          end
        end

        def to_h
          super.merge(
            confirmation_token: SecureRandom.base64(24)
          )
        end
      end
    end
  end
end
