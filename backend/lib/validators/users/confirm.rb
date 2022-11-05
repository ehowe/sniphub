require_relative "../validator"

require "securerandom"
require "uri"

class Sniphub
  module Validators
    module Users
      class Confirm < Sniphub::Validators::Validator
        required :id
        required :token

        def validate
          unless user
            errors.push({ "confirmation_token" => "invalid" })
          end
        end

        def user
          @user ||= Sniphub::User.where(id: id, confirmation_token: token).first
        end
      end
    end
  end
end
