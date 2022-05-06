require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      within '.question' do
        fill_in 'Your question title', with: 'edited title'
        fill_in 'Your question body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit question_path(question)
      expect(page).to_not have_content "Body can't be blank"
      click_on 'Edit'
      within '.question' do
        fill_in 'Your question title', with: ''
        fill_in 'Your question body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in other_user
      visit question_path(question)
      expect(page).to_not have_content "Edit"
    end
  end
end