require "dotenv"
require "bundler/setup"

Dotenv.load(".env") if File.exist?(".env")

require "jwt"
require "roda"

class Sniphub < Roda
  SECRET_KEY = ENV.fetch("APPLICATION_SECRET")
  TOKEN_EXPIRATION = ENV.fetch("TOKEN_EXPIRATION", 60 * 60 * 24)

  def self.root
    File.expand_path("./")
  end

  require_relative "./db"

  Dir["#{root}/lib/models/**/*.rb"].each { |f| require_relative f }
  Dir["#{root}/lib/presenters/**/*.rb"].each { |f| require_relative f }
  Dir["#{root}/lib/operations/**/*.rb"].each { |f| require_relative f }
  Dir["#{root}/lib/helpers/**/*.rb"].each { |f| require_relative f }

  plugin :all_verbs
  plugin :default_headers, "Access-Control-Allow-Origin" => "*", "Access-Control-Expose-Headers" => "*, Authorization"
  plugin :halt
  plugin :hash_routes
  plugin :indifferent_params
  plugin :json
  plugin :json_parser
  plugin :jwt_auth
  plugin :request_headers

  require_relative "routes"
end
