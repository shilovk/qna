# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer', "
  In order to edit an answer for the question
  As an authenticated user
  I'd like to be able to edit my own answer for the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_user) { create(:user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'authenticated use' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within ".answers #answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Change answer', with: 'edited answer'
        click_on 'Save answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within ".answers #answer-#{answer.id}" do
        click_on 'Edit answer'
        fill_in 'Change answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer", js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end
end
