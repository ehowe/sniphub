require "bundler/setup"

require "awesome_print"
require "database_cleaner/sequel"
require "factory_bot"
require "pry"
require "rspec"
require "sequel"
require "super_diff/rspec"

ENV["DB_DATABASE"]                = ENV.fetch("TEST_DB_DATABASE", "sniphub-test")
ENV["RACK_ENV"]                   = "test"
ENV["REDIS_URL"]                  = ENV.fetch("TEST_REDIS_URL", "redis://127.0.0.1:6379/15")

ENV["LOG_SQL"] ||= "false"

require_relative "../lib/db"

Sequel.extension :migration

begin
  Sniphub::DB.execute('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"')
  Sequel::Migrator.run(Sniphub::DB, "#{__dir__}/../db/migrations")
rescue Sequel::TimestampMigrator::Error # applied migrations != migration files
  tables = Sniphub::DB.tables
  Sniphub::DB.run "TRUNCATE TABLE #{tables.map { |t| %("#{t}") }.join(",")}" unless tables.empty?

  tables.each do |table|
    Sniphub::DB.drop_table? table, cascade: true
  end

  Sequel::Migrator.run(Sniphub::DB, "#{__dir__}/../db/migrations")
end

require_relative "../lib/app"

Sniphub::DB.loggers << Logger.new(STDOUT) if ENV["LOG_SQL"] == "true"

Dir[File.expand_path("./spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |c|
  c.around(:each) do |example|
    example.metadata[:skip_transaction] ? DatabaseCleaner.strategy = :truncation : DatabaseCleaner.strategy = :transaction

    DatabaseCleaner.cleaning { example.run }
  end
end

FactoryBot.find_definitions
