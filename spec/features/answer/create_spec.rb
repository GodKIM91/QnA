require 'rails_helper'

feature 'User can create answer for question', %q{
  In order to help other users with questions
  As an authenticated user
  I want to be able to create new answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create the answer with valid body' do
      fill_in 'Your answer', with: 'Already creared answer body'
      click_on 'Create'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      within '.answers' do
        expect(page).to have_content 'Already creared answer body'
      end
    end

    scenario 'try to create answer with invalid empty body' do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non authenticated user can not create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Create'
  end
end