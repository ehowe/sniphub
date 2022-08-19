require_relative "../validator"

class Sniphub
  module Validators
    module Tags
      class Update < Sniphub::Validators::Validator
        optional :name, default: ""
      end
    end
  end
end
