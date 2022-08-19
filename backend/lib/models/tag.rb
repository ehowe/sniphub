class Sniphub
  class Tag < Sequel::Model(:tags)
    plugin :timestamps, update_on_create: true
    plugin :uuid

    many_to_many :snippets, join_table: :snippets_tags
  end
end
