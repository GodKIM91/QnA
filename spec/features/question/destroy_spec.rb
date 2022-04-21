require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete my question
  As an user which created question
  I want to delete my question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can destroy his question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario "Authenticated user can't destroy other user's questions" do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario "Non-authenticated user can't destroy any question" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end