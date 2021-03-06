require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:google_url) { 'https://google.com' }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  scenario "User tries to edit other user's question" do
    sign_in other_user
    visit question_path(question)
    expect(page).to_not have_content "Edit"
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in user
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit'

      within '.question' do
        fill_in 'Your question title', with: 'edited title'
        fill_in 'Your question body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector(:xpath, './/input[@id="question_title"]')
        expect(page).to_not have_selector(:xpath, './/textarea[@id="question_body"]')
      end
    end

    scenario 'edits his question with errors' do
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

    scenario 'added one more link to his question' do
      within '.question' do
        expect(page).to_not have_link 'My gist', href: google_url
        click_on 'Edit'
        click_on 'Add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: google_url
        click_on 'Save'
        expect(page).to have_link 'My gist', href: google_url
      end
    end

    scenario 'edits his question attachment' do
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Edit'
      within '.question' do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'delete his question attachments' do
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Edit'
      within '.question' do
        click_on 'Delete file'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'delete his question link' do
      within '.question' do
        click_on 'Edit'
        click_on 'Add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: google_url
        click_on 'Save'
        expect(page).to have_link 'My gist', href: google_url
        click_on 'Delete link'
        expect(page).to_not have_link 'My gist', href: google_url
      end
    end
  end
end

# rspec spec/features/question/edit_spec.rb