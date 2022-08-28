require_relative "base"

class Sniphub
  class UserPresenter < Presenter
    def attributes
      object.values.except(:password_digest).merge(
        created_at: object.created_at.iso8601,
        updated_at: object.updated_at.iso8601,
      )
    end
  end
end
