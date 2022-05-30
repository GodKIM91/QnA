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

    scenario 'asks an answer with attached files' do
      fill_in 'Your answer', with: 'Already creared answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Non authenticated user can not create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Create'
  end

  describe 'miltiple sessions' do
    scenario "new answer appears on another user's question page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Already creared answer body'
        click_on 'Create'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        within '.answers' do
          expect(page).to have_content 'Already creared answer body'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Already creared answer body'
      end
    end
  end
end

# rspec spec/features/answer/create_spec.rb