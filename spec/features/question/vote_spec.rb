require 'rails_helper'

feature "User voite for question", %q{
  to show that he has the same problem
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:voting_user) { create(:user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(voting_user)
      visit question_path(question)
      expect(page).to have_content question.body
    end

    scenario 'can like question' do
      expect(page).to have_content 'Question rank: 0'
      click_on 'Like'
      expect(page).to have_content 'Question rank: 1'
    end

    scenario 'can dislike question' do
      expect(page).to have_content 'Question rank: 0'
      click_on 'Dislike'
      expect(page).to have_content 'Question rank: -1'
    end

    scenario 'can cancel his like/dislike' do
      expect(page).to have_content 'Question rank: 0'
      click_on 'Like'
      expect(page).to have_content 'Question rank: 1'
      click_on 'Like'
      expect(page).to have_content 'Question rank: 0'
      click_on 'Dislike'
      expect(page).to have_content 'Question rank: -1'
      click_on 'Dislike'
      expect(page).to have_content 'Question rank: 0'
    end

    scenario 'can change like to dislake w/o cancel' do
      expect(page).to have_content 'Question rank: 0'
      click_on 'Like'
      expect(page).to have_content 'Question rank: 1'
      click_on 'Dislike'
      expect(page).to have_content 'Question rank: -1'
    end
  end

  scenario 'Authenticated question author cant like/dislike question', js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end

  scenario 'Unauthenticated user cant like/dislike question', js: true do
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end
end

# rspec spec/features/question/vote_spec.rb