require_relative "../validator"

class Sniphub
  module Validators
    module Tags
      class Create < Sniphub::Validators::Validator
        optional :name, default: ""
      end
    end
  end
end
