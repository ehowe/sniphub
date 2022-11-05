require_relative "../result"

class Sniphub
  module Operations
    module Auth
      module Local
        module_function

        def call(params)
          u = Sniphub::User[username: params.fetch("username")]

          return Result.new(:error, { "message" => "Invalid username or password" }) unless u && u.authenticate(params.fetch("password"))
          return Result.new(:error, { "message" => "User is not confirmed" }) unless u&.confirmed?

          return Result.new(:ok, u)
        end
      end
    end
  end
end
