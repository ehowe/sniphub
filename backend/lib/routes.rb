class Sniphub
  route do |r|
    r.on "api" do
      r.on "snippets" do
        r.get do
          { snippets: Sniphub::Snippet.all.map { |s| Sniphub::SnippetPresenter.display(s) } }
        end

        r.is do
          r.post do
            operation = Sniphub::Operations::Snippets::Create.(params)

            unless operation.success?
              r.halt(422, operation.result)
            end

            { snippet: SnippetPresenter.display(operation.result) }
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
