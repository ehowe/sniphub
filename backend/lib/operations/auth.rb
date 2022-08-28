require_relative "./auth/github"

class Sniphub
  module Operations
    module Auth
      PROVIDERS = {
        "github" => Github
      }
    end
  end
end
