require_relative "../validator"

class Sniphub
  module Validators
    module Snippets
      class Create < Sniphub::Validators::Validator
        optional :content, default: ""
        optional :language, default: ""
        optional :name, default: ""
        optional :public, default: true
      end
    end
  end
end
