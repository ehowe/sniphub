require "swagger_helper"

describe "Users API", type: :doc, swagger_doc: "v1.json" do
  path "/users/current" do
    get "Retrieves the current user" do
      let(:user) { create(:user) }

      tags "Users"
      security [ apiKey: [] ]
      produces "application/json"
      consumes "application/json"

      response "200", "Current User" do
        include_context "jwt helper"

        schema type: :object,
          required: [:user],
          properties: {
            user: {
              "$ref" => "#/components/schemas/user",
            }
          }

        validate_schema!
      end

      response "403", "Forbidden" do
        schema type: :object,
          required: ["message"],
          properties: { message: { type: :string } }

        context "without the header set" do
          it "notifies the user that the header is missing" do |example|
            submit_request(example.metadata)

            expect(@body[:message]).to eq("No authorization header")
          end
        end

        context "with a nil header" do
          let!(:authorization) { nil }

          it "notifies the user that the header is invalid" do |example|
            submit_request(example.metadata)

            expect(@body[:message]).to eq("An unknown error occurred")
          end
        end

        context "with an expired header" do
          let(:expiration) { (Time.now - 10).to_i }

          include_context "jwt helper"

          it "notifies that the header is expired" do |example|
            submit_request(example.metadata)

            expect(@body[:message]).to eq("Token expired")
          end
        end
      end
    end
  end
end
