require "swagger_helper"

describe "Snippets API", type: :doc, swagger_doc: "v1.json" do
  path "/snippets" do
    get "Lists snippets" do
      let(:user) { create(:user) }

      before(:each) do
        create(:snippet, user:)
        create(:snippet, user:)
        create(:snippet, user:, public: false)
      end

      tags "Snippets"
      security [ apiKey: [] ]
      produces "application/json"
      consumes "application/json"

      response "200", "Snippets" do
        schema type: :object,
          required: [:snippets],
          properties: {
            snippets: {
              type:  :array,
              items: {
                "$ref" => "#/components/schemas/snippet",
              },
            },
          }

        context "unauthenticated" do
          it "Lists public snippets" do |example|
            submit_request(example.metadata)

            expect(@body[:snippets].count).to eq(2)
          end
        end

        context "authenticated" do
          include_context "jwt helper"

          it "Lists public and private snippets" do |example|
            submit_request(example.metadata)

            expect(@body[:snippets].count).to eq(3)
          end
        end
      end
    end

    post "Creates a snippet" do
      include_context "jwt helper"

      tags "Snippets"
      security [ apiKey: [] ]
      produces "application/json"
      consumes "application/json"

      parameter(
        name:        :body,
        description: "Snippet",
        in:          :body,
        schema:      {
          type:       :object,
          properties: {
            content:  { "$ref" => "#/components/schemas/snippet_content" },
            language: { "$ref" => "#/components/schemas/snippet_language" },
            name:     { "$ref" => "#/components/schemas/snippet_name" },
            public:   { "$ref" => "#/components/schemas/snippet_public" },
          }
        }
      )

      response "200", "Snippet created" do
        let(:body) do
          {
            content:  "Snippet content",
            language: "ruby",
            name:     "My first snippet",
            public:   true,
          }
        end

        schema type: :object,
          required: [:snippet],
          properties: {
            snippet: { "$ref" => "#/components/schemas/snippet" },
          }

        validate_schema!
      end
    end
  end

  context "with a snippet" do
    let(:user)    { create(:user) }
    let(:snippet) { create(:snippet, user:) }
    let(:id)      { snippet.id }

    include_context "jwt helper"

    path "/snippets/{id}" do
      put "Updates a snippet" do

        tags "Snippets"
        security [ apiKey: [] ]
        produces "application/json"
        consumes "application/json"

        parameter name: :id, in: :path, required: true, type: :uuid
        parameter(
          name:        :body,
          description: "Snippet",
          in:          :body,
          schema:      {
            type:       :object,
            properties: {
              content:  { "$ref" => "#/components/schemas/snippet_content" },
              language: { "$ref" => "#/components/schemas/snippet_language" },
              name:     { "$ref" => "#/components/schemas/snippet_name" },
              public:   { "$ref" => "#/components/schemas/snippet_public" },
            }
          }
        )

        response "403", "Unauthorized" do
          let(:authorization) { nil }
          let(:body) do
            {
              content:  "Updated content",
              language: "newlang",
              name:     "My first snippet update",
              public:   false,
            }
          end

          schema type: :object,
            required: [:message],
            properties: {
              message: { type: :string }
            }

          validate_schema!
        end

        response "200", "Snippet updated" do
          let(:body) do
            {
              content:  "Updated content",
              language: "newlang",
              name:     "My first snippet update",
              public:   false,
            }
          end

          schema type: :object,
            required: [:snippet],
            properties: {
              snippet: { "$ref" => "#/components/schemas/snippet" },
            }

          validate_schema!
        end

        response "404", "Snippet not found" do
          let(:id)   { SecureRandom.uuid }
          let(:body) { {} }

          validate_schema!
        end
      end
    end

    path "/snippets/{id}/tags" do
      post "Add a tag to a snippet" do
        let(:user)    { create(:user) }
        let(:snippet) { create(:snippet, user:) }
        let(:id)      { snippet.id }
        let(:tag)     { create(:tag) }

        let(:body) do
          { tag_ids: [ tag.id ] }
        end

        tags "Snippets"
        security [ apiKey: [] ]
        produces "application/json"
        consumes "application/json"

        parameter name: :id, in: :path, required: true, type: :uuid
        parameter(
          name: :body,
          description: "Tags",
          in: :body,
          schema: {
            type:       :object,
            properties: {
              tag_ids: {
                type:  :array,
                items: { type: :string, format: :uuid },
              }
            }
          }
        )

        response "403", "Unauthorized" do
          let(:authorization) { nil }

          schema type: :object,
            required: [:message],
            properties: {
              message: { type: :string }
            }

          validate_schema!
        end

        response "200", "Tag added" do
          schema type: :object,
            required: [:snippet],
            properties: {
              snippet: { "$ref" => "#/components/schemas/snippet" },
            }

          validate_schema!
        end
      end
    end
  end
end
