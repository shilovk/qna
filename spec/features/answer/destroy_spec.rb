# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete own answer', "
  In order to remove the question
  As an authenticated user
  I'd like to be able to destroy my answer
" do
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes own question', js: true do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete answer'
      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_content answer.body
    end

    scenario 'deletes not own question', js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to deletes an answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
