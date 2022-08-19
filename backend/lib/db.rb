require "dotenv"

Dotenv.load(".env") if File.exist?(".env")

require "roda"
require "sequel"

class Sniphub < Roda
  DB = Sequel.connect(ENV.fetch("DATABASE_URL"), user: ENV["DB_USER"], password: ENV["DB_PASSWORD"])
end
