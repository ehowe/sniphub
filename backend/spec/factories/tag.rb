FactoryBot.define do
  factory :tag, class: Sniphub::Tag do
    sequence(:name) { |n| "Tag #{n}" }
  end
end
