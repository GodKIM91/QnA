require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end
  
    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
      click_on 'Ask'
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Test question body'
    end
  
    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with reward' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Test question body'
      fill_in 'Reward title', with: 'Reward title'
      attach_file 'Reward file', "#{Rails.root}/app/assets/images/best_answer.png"
      click_on 'Ask'
      expect(page).to have_content "You can get a reward 'Reward title' for the best answer"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

# rspec spec/features/question/create_spec.rb
