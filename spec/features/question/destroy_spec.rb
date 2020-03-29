# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete own question', "
  In order to remove the question
  As an authenticated user
  I'd like to be able to destroy my question
" do
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes own question' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Your question was succesfully deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'deletes not own question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to deletes a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
