require 'rails_helper'

feature 'User can vote for answer to the question', "
  In order to vote for not own answer to the question
  As an authenticated user
  I'd like to be able to like or dislike for answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote for not own answer', js: true do
      within "#answer-#{other_answer.id}" do
        within '.vote' do
          expect(page).to have_link 'Up'
          expect(page).to have_link 'Down'

          within '.score' do
            expect(page).to have_content other_answer.score
          end
        end
      end
    end

    scenario 'votes up for not own answer', js: true do
      within "#answer-#{other_answer.id}" do
        within '.vote' do
          click_on 'Up'

          within '.score' do
            expect(page).to have_content other_answer.score
          end
        end
      end
    end

    scenario 'votes down for not own answer', js: true do
      within "#answer-#{other_answer.id}" do
        within '.vote' do
          click_on 'Down'

          within '.score' do
            expect(page).to have_content other_answer.score
          end
        end
      end
    end

    scenario 'can not to vote for own answer', js: true do
      within "#answer-#{answer.id}" do
        within '.vote' do
          expect(page).not_to have_link 'Up'
          expect(page).not_to have_link 'Down'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for an answer to the question' do
    visit question_path(question)

    within "#answer-#{other_answer.id}" do
      within '.vote' do
        expect(page).not_to have_link 'Up'
        expect(page).not_to have_link 'Down'
      end
    end
  end
end
