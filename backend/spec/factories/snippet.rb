FactoryBot.define do
  factory :snippet, class: Sniphub::Snippet do
    transient do
      tag_names { [] }
    end

    sequence(:name)    { |n| "Snippet #{n}" }
    sequence(:content) { |n| "Content #{n}" }
    language           { "ruby" }
    user

    after(:create) do |snippet, evaluator|
      evaluator.tag_names.each do |tag_name|
        tag = create(:tag, name: tag_name)

        snippet.add_tag(tag)
      end
    end
  end
end
