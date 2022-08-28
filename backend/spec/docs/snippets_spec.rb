require "swagger_helper"

describe "Snippets API", type: :doc, swagger_doc: "v1.json" do
  path "/snippets" do
    get "Lists snippets" do
      let(:user) { create(:user) }

      before(:each) do
        create(:snippet, user: user)
        create(:snippet, user: user)
        create(:snippet, user: user, public: false)
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
    let(:snippet) { create(:snippet) }
    let(:id)      { snippet.id }

    path "/snippets/{id}" do
      put "Updates a snippet" do
        tags "Snippets"
        security []
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
        let(:snippet) { create(:snippet) }
        let(:id)      { snippet.id }

        tags "Snippets"
        security []
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

        response "200", "Tag added" do
          let(:tag) { create(:tag) }

          schema type: :object,
            required: [:snippet],
            properties: {
              snippet: { "$ref" => "#/components/schemas/snippet" },
            }

          let(:body) do
            { tag_ids: [ tag.id ] }
          end

          validate_schema!
        end
      end
    end
  end
end
