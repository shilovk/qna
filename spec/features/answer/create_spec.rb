# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to create an answer for the question
  As an authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates an answer to the question', js: true do
      fill_in 'Your answer', with: "Test answer's body"
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content "Test answer's body"
      end
    end

    scenario 'creates an answer with errors', js: true do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates an answer with attached files', js: true do
      fill_in 'Your answer', with: "Test answer's body"

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(page).to  have_link 'rails_helper.rb'
      expect(page).to  have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user creates an answer to the question' do
    visit question_path(question)

    fill_in 'Your answer', with: "Test answer's body"
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
