require_relative "./auth/github"

class Sniphub
  module Operations
    module Auth
      PROVIDERS = {
        "github" => Github,
        "local"  => Local,
      }
    end
  end
end
