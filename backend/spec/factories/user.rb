FactoryBot.define do
  factory :user, class: Sniphub::User do
    first_name            { "Bob" }
    last_name             { "Smith" }
    password              { "password" }
    password_confirmation { "password" }
    sequence(:username)   { |n| "bobsmith#{n}" }

    trait :github do
      external_provider { "github" }

      password_digest { nil }
    end

    trait :pending_confirmation do
      confirmation_token { SecureRandom.base64(24) }
    end
  end
end
