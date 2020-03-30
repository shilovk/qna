# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer', "
  In order to edit an answer for the question
  As an authenticated user
  I'd like to be able to edit my own for the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'authenticated use' do
    scenario 'edits his answer', js: true do
        sign_in user
        visit question_path(question)

        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other users's answer"
  end
end
