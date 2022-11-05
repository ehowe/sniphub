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

  path "/users/register" do
    post "Registers a user" do
      tags "Users"
      security []
      produces "application/json"
      consumes "application/json"

      parameter name: :body, in: :body, description: "User attributes", schema: {
        type:       :object,
        required:   [
          :first_name,
          :last_name,
          :password,
          :password_confirmation,
          :username,
        ],
        properties: {
          first_name:            { type: :string },
          last_name:             { type: :string },
          password:              { type: :string },
          password_confirmation: { type: :string },
          username:              { type: :string },
        }
      }

      response "200", "User Registered" do
        let(:body) do
          {
            "first_name"            => "Bob",
            "last_name"             => "Smith",
            "password"              => "Password1!",
            "password_confirmation" => "Password1!",
            "username"              => "bobsmith@example.com",
          }
        end

        schema "$ref" => "#/components/schemas/user_response"

        validate_schema!
      end

      response "422", "Invalid user attribues" do
        let(:first_name)            { "Bob" }
        let(:last_name)             { "Smith" }
        let(:password)              { "Password1!" }
        let(:password_confirmation) { password }
        let(:username)              { "bobsmith@example.com" }
        let(:body) do
          {
            "first_name"            => first_name,
            "last_name"             => last_name,
            "password"              => password,
            "password_confirmation" => password_confirmation,
            "username"              => username,
          }
        end

        schema type: :array,
          items: {
            type:       :object,
            properties: {
              username:              { type: :string },
              password:              { type: :string },
              password_confirmation: { type: :string },
            }
          }

        context "invalid username" do
          let(:username) { "bobsmith" }

          it "returns an invalid message" do |example|
            submit_request(example.metadata)

            expect(@body).to contain_exactly(a_hash_including(username: "must be an email address"))
          end
        end

        context "invalid password" do
          let(:password)              { "bobsmith" }
          let(:password_confirmation) { "notbobsmith" }

          it "returns an invalid message" do |example|
            submit_request(example.metadata)

            expect(@body).to contain_exactly(
              a_hash_including(password: "password and confirmation are not equal"),
              a_hash_including(password_confirmation: "password and confirmation are not equal")
            )
          end
        end
      end
    end
  end
end
