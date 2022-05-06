require 'rails_helper'

feature 'User can choose best answer for his question', %q{
  In order to select best answer
  As an author of question
  I'd like ti be able choose best answer
} do

  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario 'Unauthenticated user cant choose best answer' do
    visit question_path(question)
    p answer
    expect(page).to_not have_link 'Set as best'
  end

  scenario "Not author of question cant choose best answer", js: true do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Set as best'
  end

  describe 'User as author of question', js: true  do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can choose best answer' do
      within "#answer_#{answer.id}" do
        expect(page).not_to have_content 'Best answer!'
        click_on 'Set as best'
        expect(page).to have_content 'Best answer!'
      end
    end

    scenario 'choose other answer as best' do
      expect(page).to_not have_content 'Best answer!'

      within "#answer_#{answers.first.id}" do
        click_on 'Set as best'
        expect(page).to have_content 'Best answer!'
        expect(page).to_not have_content 'Set as best'
      end

      within "#answer_#{answers.last.id}" do
        expect(page).to have_content 'Set as best'
        click_on 'Set as best'
        expect(page).to_not have_content 'Set as best'
        expect(page).to have_content 'Best answer!'
      end

      within "#answer_#{answers.first.id}" do
        expect(page).to_not have_content 'Best answer!'
        expect(page).to have_content 'Set as best'
      end
    end
  end
end