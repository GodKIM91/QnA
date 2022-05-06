require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  scenario "User tries to edit other user's answer" do
    sign_in other_user
    visit question_path(question)
    expect(page).to_not have_content "Edit"
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer attachment' do
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
        expect(page).to have_link 'rails_helper.rb'
      end

      click_on 'Edit'
      within '.answers' do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his answer with errors' do
      expect(page).to_not have_content "Body can't be blank"
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end
    
    
  end
end

#rspec spec/features/answer/edit_spec.rb