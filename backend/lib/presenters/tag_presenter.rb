require_relative "base"

class Sniphub
  class TagPresenter < Presenter
    def attributes
      object.values.merge(
        created_at: object.created_at.iso8601,
        updated_at: object.updated_at.iso8601,
      )
    end
  end
end
