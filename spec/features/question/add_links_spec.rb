require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit new_question_path
    end
  
    scenario 'adds link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      click_on 'Add link'
  
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: google_url
  
      click_on 'Ask'
  
      expect(page).to have_link 'My gist', href: google_url
    end

    scenario 'adds gist link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      click_on 'Add link'
  
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
  
      click_on 'Ask'
  
      expect(page).to have_content "Hello, world!"
    end
  
    scenario 'removes link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      click_on 'Add link'
      
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: google_url
      click_on 'Remove link'
  
      click_on 'Ask'
  
      expect(page).to_not have_link 'My gist', href: google_url
    end
  end
end

#rspec spec/features/question/add_links_spec.rb