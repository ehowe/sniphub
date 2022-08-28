require "roda"

require_relative "../../lib/models/user"

class Sniphub
  module Helpers
    module JWTAuth
      module InstanceMethods
        def current_user
          request.env["CURRENT_USER"]
        end

        def with_optional_jwt(&block)
          operation = Sniphub::Operations::ValidateJWT.(request.headers)

          request.env["CURRENT_USER"] = operation.result if operation.success?

          block.call(operation.success?)
        end

        def with_valid_jwt!(&block)
          operation = Sniphub::Operations::ValidateJWT.(request.headers)

          if operation.success?
            request.env["CURRENT_USER"] = operation.result if operation.success?

            block.call
          else
            request.halt(403, { message: operation.result })
          end
        end
      end
    end
  end
end

Roda::RodaPlugins.register_plugin(:jwt_auth, Sniphub::Helpers::JWTAuth)
