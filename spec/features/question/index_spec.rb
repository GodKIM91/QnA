require 'rails_helper'

feature 'User can see questions list', %q{
  In order to view needed questions
  As an user
  I want to view all questions
} do

  given!(:questions) { create_list(:question, 5)}

  scenario 'Any user can see the list of questions' do
    visit questions_path
    expect(page).to have_content 'Questions'
    questions.each { |question| expect(page).to have_content(question.title) }
  end
end