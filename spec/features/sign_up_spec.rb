require 'rails_helper'

feature 'User can sing up', %q{
  I'd like to be able to sign in
  And to ask questions
  And to answer questions
} do

  background { visit new_user_registration_path }
  
  scenario 'User with valid data can register' do
    fill_in 'Email', with: 'test_user@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User w/o data cant register' do
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end

  scenario 'User with invalid email cant register' do
    fill_in 'Email', with: 'email'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'
    expect(page).to have_content 'Email is invalid'
  end

  scenario 'User with different passwords cant register' do
    fill_in 'Email', with: 'test_user@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '987654321'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  given(:user) { create(:user) }

  scenario 'User cant register twice with the same email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content "Email has already been taken"
  end
end