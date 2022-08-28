require_relative "./spec_helper"

require "swagalicious"

DEFINITIONS = %w(common v1).each_with_object({}) do |filename, hash|
  hash.merge!(Oj.load(File.read(File.expand_path("docs/definitions/#{filename}.json", __dir__))))
end.freeze

RSpec.configure do |c|
  c.raise_errors_for_deprecations!
  c.swagger_root = "public/swagger_docs"
  c.swagger_docs = {
    "v1.json" => {
      servers: [ { url: "/api" } ],
      info:    {
        title:   "API",
        version: "v1",
      }
    },
  }.tap do |docs|
    common_defs = DEFINITIONS["common"]
    docs.each.each do |path, doc|
      docs[path] = {
        openapi:    "3.0.3",
        components: {
          schemas:         DEFINITIONS[doc.fetch(:info).fetch(:version)].merge(common_defs).symbolize_keys,
          securitySchemes: {
            apiKey: {
              in:       :header,
              name:     "authorization",
              required: false,
              type:     :apiKey,
            }

          }
        }
      }.merge(doc)
    end
  end
end
