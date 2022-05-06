require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete my answer
  As an user which created answer
  I want to delete my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do
    scenario 'can destroy his answer' do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Delete answer'

      expect(current_path).to eq question_path(answer.question)
      expect(page).to_not have_content answer.body
    end

    scenario "can't destroy other user's answers" do
      sign_in(user)
      visit question_path(answer.question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario "Non-authenticated user can't destroy any answer" do
    visit question_path answer.question
    expect(page).to_not have_link 'Delete answer'
  end
end