begin
  require "rspec/core/rake_task"
rescue LoadError
end

namespace :specs do
  desc "Generate Swagger JSON files from integration specs"

  begin
    RSpec::Core::RakeTask.new("swaggerize") do |t|
      t.pattern = ENV.fetch("PATTERN", "spec/docs/**/*_spec.rb")

      t.rspec_opts = ["--format Swagalicious::SwaggerFormatter", "--order defined"]
    end
  rescue
  end
end

task specs: ["specs:swaggerize"]
