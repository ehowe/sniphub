require_relative "../result"
require_relative "../../validators/snippets/create"

class Sniphub
  module Operations
    module Snippets
      module Tag
        module_function

        def call(snippet, params = {})
          insert_params = Array(params[:tag_ids]).compact.map do |id|
            { snippet_id: snippet.id, tag_id: id }
          end

          Sniphub::DB[:snippets_tags].insert_conflict.multi_insert(insert_params)

          Sniphub::Operations::Result.new(:ok, Sniphub::Snippet.eager(:tags).with_pk(snippet.id))
        end
      end
    end
  end
end
