require_relative "base"
require_relative "tag_presenter"

class Sniphub
  class SnippetPresenter < Presenter
    def attributes
      object.values.merge(
        created_at: object.created_at.iso8601,
        updated_at: object.updated_at.iso8601,
        tags:       object.tags.map { |t| TagPresenter.display(t) }
      )
    end
  end
end
