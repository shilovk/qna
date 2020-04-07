# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the question', "
  In order to vote for not own question
  As an authenticated user
  I'd like to be able to up or down vote for the question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: other_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(other_question)
    end

    scenario 'can vote for not own question', js: true do
      within '.question .vote' do
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'

        within '.score' do
          expect(page).to have_content other_question.score
        end
      end
    end

    scenario 'votes up for not own question', js: true do
      within '.question .vote' do
        click_on 'Up'

        within '.score' do
          expect(page).to have_content other_question.score
        end
      end
    end

    scenario 'votes down for not own question', js: true do
      within '.question .vote' do
        click_on 'Down'

        within '.score' do
          expect(page).to have_content other_question.score
        end
      end
    end

    scenario 'can not to vote for own question', js: true do
      visit question_path(question)

      within '.question .vote' do
        expect(page).not_to have_link 'Up'
        expect(page).not_to have_link 'Down'

        within '.score' do
          expect(page).to have_content question.score
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for an question to the question' do
    visit question_path(question)

    within '.question .vote' do
      expect(page).not_to have_link 'Up'
      expect(page).not_to have_link 'Down'

      within '.score' do
        expect(page).to have_content question.score
      end
    end
  end
end
