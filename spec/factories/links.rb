FactoryBot.define do
  factory :link do
    name { "Already created link" }
    url { "https://github.com" }

    trait :gist do
      name { "gist_link" }
      url { "https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c" }
    end
  end
end
