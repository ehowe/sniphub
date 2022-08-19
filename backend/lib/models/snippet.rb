class Sniphub
  class Snippet < Sequel::Model(:snippets)
    plugin :timestamps, update_on_create: true
    plugin :uuid

    many_to_many :tags, join_table: :snippets_tags
  end
end
