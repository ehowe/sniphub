require_relative "./result"

class Sniphub
  module Operations
    module ValidateJWT
      module_function

      def call(headers)
        authorization_header = headers["Authorization"]

        return Sniphub::Operations::Result.new(:error, "No authorization header") unless authorization_header

        begin
          decoded_token = JWT.decode(authorization_header.split(" ").last, Sniphub::SECRET_KEY, "HS256")&.first

          u = Sniphub::User.with_pk(decoded_token["id"])

          return Sniphub::Operations::Result.new(:error, "User not found") unless u

          return Result.new(:ok, u)
        rescue JWT::ExpiredSignature
          return Sniphub::Operations::Result.new(:error, "Token expired")
        rescue JWT::VerificationError
          return Sniphub::Operations::Result.new(:error, "Signature mismatch")
        rescue
          return Sniphub::Operations::Result.new(:error, "An unknown error occurred")
        end
      end
    end
  end
end
