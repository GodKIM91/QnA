FactoryBot.define do
  sequence :body do |n|
    "Answer_body_#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end