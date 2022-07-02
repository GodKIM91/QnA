require 'rails_helper'

feature 'Users and guests can search something in app', elasticsearch: true do
  given(:user) { create(:user) }

  background do
    @question = create(:question, title: 'title 1', body: 'body 1', user: user)
    @answer = create(:answer, question: @question, body: 'body 2')
    @comment = create(:comment, commentable: @question, body: 'body 3', user: user)
    refresh_indexes
    visit root_path
  end

  describe 'User and guest can search' do
    scenario 'Questions by body' do
      within '.search' do
        select 'Question', from: 'model'
        fill_in 'query', with: 'body'
        click_on 'Search'
      end

      expect(page).to have_link(@question.title)
      expect(page).to have_text(@question.body)
    end
    scenario 'Questions by title' do
      within '.search' do
        select 'Question', from: 'model'
        fill_in 'query', with: 'title'
        click_on 'Search'
      end

      expect(page).to have_link(@question.title)
      expect(page).to have_text(@question.body)
    end
    scenario 'Answers' do
      within '.search' do
        select 'Answer', from: 'model'
        fill_in 'query', with: 'body'
        click_on 'Search'
      end
      expect(page).to have_link(@answer.question.title)
      expect(page).to have_text(@answer.body)
    end
    scenario 'Comments' do
      within '.search' do
        select 'Comment', from: 'model'
        fill_in 'query', with: 'body'
        click_on 'Search'
      end
      expect(page).to have_link(@comment.commentable.title)
      expect(page).to have_text(@comment.body)
    end

    scenario 'Users' do
      within '.search' do
        select 'User', from: 'model'
        fill_in 'query', with: user.email
        click_on 'Search'
      end
      expect(page).to have_link(user.email)
      expect(page).to have_text(user.email)
      click_on user.email
      expect(page).to have_text "Questions of #{user.email}"
    end

    scenario 'All models' do
      within '.search' do
        select 'All', from: 'model'
        fill_in 'query', with: 'body'
        click_on 'Search'
      end
      expect(page).to have_text 'body 1'
      expect(page).to have_text 'body 2'
      expect(page).to have_text 'body 3'
    end
  end

  describe 'Empty search' do
    scenario 'redirect to root and show notice' do
      within '.search' do
        fill_in 'query', with: ''
        click_on 'Search'
      end

      expect(page).to have_text 'Questions list:'
      expect(page).to have_text 'Nothing to search'
    end
  end

  describe 'Search w/o results' do
    scenario 'renders results notice' do
      within '.search' do
        fill_in 'query', with: 'invalid request'
        click_on 'Search'
      end

      expect(page).to have_text 'No matches found'
    end
  end
end

# rspec spec/features/search/search_spec.rb