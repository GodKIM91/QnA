require 'rails_helper'

feature "User voite for answer", %q{
  in order other users see better answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:voting_user) { create(:user) }


  describe 'Authenticated user', js: true do

    background do
      sign_in(voting_user)
      visit question_path(question)
      expect(page).to have_content question.body
      expect(page).to have_content answer.body
    end

    scenario 'can like answer' do
      within '.answers' do
        within '.rank' do
          expect(page).to have_content 'Answer rank: 0'
          click_on 'Like'
          expect(page).to have_content 'Answer rank: 1'
        end
      end
    end

    scenario 'can dislike answer' do
      within '.answers' do
        within '.rank' do
          expect(page).to have_content 'Answer rank: 0'
          click_on 'Dislike'
          expect(page).to have_content 'Answer rank: -1'
        end
      end
    end

    scenario 'can cancel his like/dislike' do
      within '.answers' do
        within '.rank' do
          expect(page).to have_content 'Answer rank: 0'
          click_on 'Like'
          expect(page).to have_content 'Answer rank: 1'
          click_on 'Like'
          expect(page).to have_content 'Answer rank: 0'
          click_on 'Dislike'
          expect(page).to have_content 'Answer rank: -1'
          click_on 'Dislike'
          expect(page).to have_content 'Answer rank: 0'
        end
      end
    end

    scenario 'can change like to dislake w/o cancel' do
      within '.answers' do
        within '.rank' do
          expect(page).to have_content 'Answer rank: 0'
          click_on 'Like'
          expect(page).to have_content 'Answer rank: 1'
          click_on 'Dislike'
          expect(page).to have_content 'Answer rank: -1'
        end
      end
    end
  end

  scenario 'Authenticated answer author cant like/dislike answer', js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    within '.answers' do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end
  end

  scenario 'Unauthenticated user cant like/dislike answer', js: true do
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end
end

# rspec spec/features/answer/vote_spec.rb