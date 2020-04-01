# frozen_string_literal: true

require 'rails_helper'

feature 'User can set best answer', "
  In order to set a best answer for the question
  As an author of the question
  I'd like to be able to choose a best answer for my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_user) { create(:user) }

  scenario 'Question author may set a best answer for his question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Set the best'

      expect(page).to have_content 'Best answer'
    end
  end

  scenario 'Authenticated user tries to set a best answer for not own question' do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Set the best'
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer for question' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Set the best'
    end
  end
end
