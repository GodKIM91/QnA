FactoryBot.define do
  factory :reward do
    sequence :title do |n|
      "Reward_#{n}"
    end
    question
    file { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/best_answer.png", 'best_answer.png') }
  end
end