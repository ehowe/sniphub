require "faraday"
require "oj"

require_relative "../result"

class Sniphub
  module Operations
    module Auth
      module Github
        module_function

        def call(params)
          request_params = {
            "client_id"     => ENV["GITHUB_CLIENT_ID"],
            "client_secret" => ENV["GITHUB_CLIENT_SECRET"],
            "code"          => params[:code],
            "redirect_uri"  => ENV["OAUTH2_REDIRECT_URI"],
          }

          response = Faraday.post("https://github.com/login/oauth/access_token", Oj.dump(request_params), { "Content-Type" => "application/json", "Accept" => "application/json" })

          return Result.new(:error, "Invalid access token response") unless response.status == 200

          parsed_response = Oj.load(response.body)
          access_token    = parsed_response["access_token"]

          user_response = Faraday.get("https://api.github.com/user", nil, { "Authorization" => "token #{access_token}" })

          return Result.new(:error, "Invalid API response") unless user_response.status == 200

          user = Oj.load(user_response.body)

          user_record = Sniphub::User.find_or_create(username: user["login"]) do |u|
            api_name = user["name"].split(" ")

            u.external_provider = "github"
            u.first_name        = api_name[0]
            u.last_name         = api_name[1]
          end

          Result.new(:ok, user_record)
        end
      end
    end
  end
end
