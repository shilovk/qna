# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to create an answer for the question
  As an authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates an answer to the question' do
      fill_in 'Your answer', with: "Test answer's body"
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content "Test answer's body"
      end
    end

    scenario 'create an answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user creates an answer to the question' do
    visit question_path(question)

    fill_in 'Your answer', with: "Test answer's body"
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
