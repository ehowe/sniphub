class Sniphub
  route do |r|
    r.on "api" do
      r.options do
        response["Access-Control-Allow-Methods"]  = "POST"
        response["Access-Control-Allow-Headers"]  = "Content-Type, Authorization"

        {}
      end

      r.on "auth" do
        r.post do
          operation = Sniphub::Operations::Auth::PROVIDERS[params["provider"]].(params)

          unless operation.success?
            r.halt(400, operation.result)
          end

          response["Authorization"] = JWT.encode(operation.result, SECRET_KEY, "HS256")

          { user: Sniphub::UserPresenter.display(operation.result) }
        end
      end

      r.on "users" do
        r.is "current" do
          with_valid_jwt! do
            { user: Sniphub::UserPresenter.display(current_user) }
          end
        end
      end

      r.on "snippets" do
        r.get do
          with_optional_jwt do |valid|
            snippets = valid ?
              Sniphub::Snippet.for_user(user_id: current_user.id) :
              Sniphub::Snippet.dataset.public

            { snippets: snippets.all.map { |s| Sniphub::SnippetPresenter.display(s) } }
          end
        end

        r.is do
          r.post do
            with_valid_jwt! do
              operation = Sniphub::Operations::Snippets::Create.(params: params, user: current_user)

              unless operation.success?
                r.halt(422, operation.result)
              end

              { snippet: SnippetPresenter.display(operation.result) }
            end
          end
        end

        r.on String do |snippet_id|
          snippet = Snippet.eager(:tags).with_pk(snippet_id)

          r.halt(404) unless snippet

          r.put do
            operation = Sniphub::Operations::Snippets::Update.(snippet, params)

            unless operation.success?
              return operation.result
            end

            { snippet: SnippetPresenter.display(operation.result) }
          end

          r.is "tags" do
            r.post do
              operation = Sniphub::Operations::Snippets::Tag.(snippet, params)

              unless operation.success?
                r.halt(422, operation.result)
              end

              { snippet: SnippetPresenter.display(operation.result) }
            end
          end
        end
      end

      r.is "tags" do
        r.get do
          { tags: Sniphub::Tag.all.map(&:values) }
        end

        r.is String do |tag_id|
          tag = Tag[tag_id]

          r.halt(404) unless tag

          r.put do
            operation = Sniphub::Operations::Tags::Update.(tag, params)

            unless operation.success?
              return operation.result
            end

            { tag: TagPresenter.display(operation.result) }
          end
        end
      end
    end
  end
end
