require 'rails_helper'

feature 'User can see a question and its answers', %q{
  In order to help with question
  I want to able to to view question with it's answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_pair(:answer, question: question, user: user)}

  describe 'User' do
    background { visit question_path(question) }

    scenario 'sees details of question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'sees answers of the question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end