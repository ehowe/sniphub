require_relative "../validator"

class Sniphub
  module Validators
    module Snippets
      class Update < Sniphub::Validators::Validator
        optional :name
        optional :language
        optional :content
        optional :public
      end
    end
  end
end
