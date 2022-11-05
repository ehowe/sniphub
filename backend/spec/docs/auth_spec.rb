require "swagger_helper"

describe "Auth API", type: :doc, swagger_doc: "v1.json" do
  path "/auth" do
    post "Authenticates a user" do
      let(:user) { create(:user) }

      tags "Authentication"
      consumes "application/json"
      produces "application/json"
      security []

      parameter(
        name:        :body,
        description: "Login credentials",
        in:          :body,
        schema:      {
          type:     :object,
          required: [:provider],
          username: { type: :string },
          password: { type: :string },
          provider: { type: :string, enum: [:github, :local] },
        }
      )

      response "200", "Authentication successful" do
        let(:body) do
          {
            username: user.username,
            password: "password",
            provider: :local,
          }
        end

        context "username and password authentication" do
          schema type: :object,
            required: [:user],
            properties: { "$ref" => "#/components/schemas/user" }

          validate_schema!
        end
      end

      response "403", "Invalid authentication" do
        schema "$ref" => "#/components/schemas/error"

        context "invalid username or password" do
          let(:body) do
            {
              username: user.username,
              password: "invalid_password",
              provider: :local,
            }
          end

          it "returns an invalid username or password message" do |example|
            submit_request(example.metadata)

            expect(@body[:message]).to eq("Invalid username or password")
          end
        end

        context "user is not confirmed" do
          let(:user) { create(:user, :pending_confirmation) }
          let(:body) do
            {
              username: user.username,
              password: "password",
              provider: :local,
            }
          end

          it "returns the user is not confirmed message" do |example|
            submit_request(example.metadata)

            expect(@body[:message]).to eq("User is not confirmed")
          end
        end
      end
    end
  end
end
