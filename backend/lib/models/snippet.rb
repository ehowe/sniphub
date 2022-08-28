class Sniphub
  class Snippet < Sequel::Model(:snippets)
    plugin :timestamps, update_on_create: true
    plugin :uuid

    many_to_many :tags, join_table: :snippets_tags

    many_to_one :user, class: "Sniphub::User"

    dataset_module do
      def public
        where(public: true)
      end

      def for_user(user_id:)
        where(Sequel.|({ user_id: user_id }, { public: true }))
      end
    end
  end
end
