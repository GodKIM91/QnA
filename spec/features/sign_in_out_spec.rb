require 'rails_helper'

feature 'User can sing in', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
} do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  describe 'Registered user' do
    background do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    scenario 'tries to sign in' do
      expect(page).to have_content 'Signed in successfully.'
    end
  
    scenario 'tries to log out' do
      click_on 'Log out'
      expect(page).to have_content 'Signed out successfully.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '1234567-'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end
end