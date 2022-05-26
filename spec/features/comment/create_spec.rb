require 'rails_helper'

feature 'User can leave comments' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write comment for question' do
      within '.new_question_comment' do
        fill_in 'Comment body', with: 'Already created comment for question'
        click_on 'Comment'
      end

      expect(page).to have_content 'Already created comment for question'
    end

    scenario 'can write comment for question' do
      within '.new_answer_comment' do
        fill_in 'Comment body', with: 'Already created comment for answer'
        click_on 'Comment'
      end

      expect(page).to have_content 'Already created comment for answer'
    end
  end

  describe 'guest', js: true do
    scenario 'can read comments' do\
      sign_in(user)
      visit question_path(question)
      within '.new_question_comment' do
        fill_in 'Comment body', with: 'Already created comment for question'
        click_on 'Comment'
      end
      within '.new_answer_comment' do
        fill_in 'Comment body', with: 'Already created comment for answer'
        click_on 'Comment'
      end
      click_on "Log out"
      visit question_path(question)
      expect(page).to have_content 'Already created comment for question'
      expect(page).to have_content 'Already created comment for answer'
    end
  end

  describe 'non-authenticated user', js: true do
    scenario 'cant write any comment' do
      visit question_path(question)
      expect(page).to_not have_content 'Your comment:'
      expect(page).to_not have_content 'Comment'
    end
  end
end

# rspec spec/features/comment/create_spec.rb