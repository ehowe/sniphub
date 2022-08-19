require "dotenv"
require "bundler/setup"

Dotenv.load(".env") if File.exist?(".env")

require "roda"

class Sniphub < Roda
  SECRET_KEY = ENV.fetch("APPLICATION_SECRET")

  def self.root
    File.expand_path("./")
  end

  require_relative "./db"

  Dir["#{root}/lib/models/**/*.rb"].each { |f| require_relative f }
  Dir["#{root}/lib/presenters/**/*.rb"].each { |f| require_relative f }
  Dir["#{root}/lib/operations/**/*.rb"].each { |f| require_relative f }

  plugin :all_verbs
  plugin :halt
  plugin :hash_routes
  plugin :indifferent_params
  plugin :json
  plugin :json_parser

  require_relative "routes"
end
