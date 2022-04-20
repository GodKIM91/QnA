FactoryBot.define do
  sequence :title do |n|
    "Question_title_#{n}"
  end

  factory :question do
    title
    body { "Question_body" }
    user

    trait :invalid do
      title { nil }
    end

    trait :static do
      title { 'MyTitle' }
      body { 'MyBody' }
    end
  end
end
