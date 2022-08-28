FactoryBot.define do
  factory :user, class: Sniphub::User do
    first_name          { "Bob" }
    last_name           { "Smith" }
    password_digest     { Base64.encode64("password") }
    sequence(:username) { |n| "bobsmith#{n}" }

    trait :github do
      external_provider { "github" }

      password_digest { nil }
    end
  end
end
