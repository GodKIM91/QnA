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
  given(:google_url) { 'https://google.com' }

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
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'
      within '.answers' do
        expect(page).to have_selector(:xpath, './/textarea[@id="answer_body"]')
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector(:xpath, './/textarea[@id="answer_body"]')
      end
    end

    scenario 'edits his answer attachment' do
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'
        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'added one more link to his answer' do
      within '.answers' do
        expect(page).to_not have_link 'My gist', href: google_url
        click_on 'Edit'
        click_on 'Add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: google_url
        click_on 'Save'
        expect(page).to have_link 'My gist', href: google_url
      end
      
    end

    scenario 'delete his answer attachments' do
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Edit'
      within '.answers' do
        click_on 'Delete file'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'delete his answer link' do
      within '.answers' do
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

# rspec spec/features/answer/edit_spec.rb