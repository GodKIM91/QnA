require 'rails_helper'

feature 'User can see rewards list', %q{
  If my answer is best
  As an user
  I want to view my rewards
} do

  given(:user) { create(:user) }
  given!(:rewards) { create_list(:reward, 3, user: user) }

  scenario "User opens 'my rewards' page and sees rewards" do
    sign_in(user)
    visit rewards_path
    expect(page).to have_content 'Your rewards list'

    rewards.each do |r|
      expect(page).to have_content r.title
      expect(page).to have_content r.question.title
    end
  end
end

# rspec spec/features/reward/index_spec.rb