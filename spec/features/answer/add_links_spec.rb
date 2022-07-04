require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:google_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds link when creating answer', js: true do
      fill_in 'Your answer', with: 'Already creared answer body'
  
      click_on 'Add link'
      
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: google_url
      click_on 'Create'
  
      within '.answers' do 
        expect(page).to have_link 'My gist', href: google_url
      end
    end

    scenario 'adds gist link when creating answer', js: true do
      fill_in 'Your answer', with: 'Already creared answer body'
  
      click_on 'Add link'
      
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'Create'

      visit question_path(question)

      within '.answers' do
        expect(page).to have_content "Hello, world!"
      end
    end

    scenario 'removes link when creating answer', js: true do
      fill_in 'Your answer', with: 'Already creared answer body'
  
      click_on 'Add link'
      
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: google_url
      click_on 'Remove link'

      click_on 'Create'
  
      within '.answers' do 
        expect(page).to_not have_link 'My gist', href: google_url
      end
    end
  end
end

# rspec spec/features/answer/add_links_spec.rb