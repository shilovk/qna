# frozen_string_literal: true

require 'rails_helper'

feature 'User can create award for best answer', "
  In order to award best answer on created question
  As an authenticated user
  I'd like to be able to ask the question with set a award
" do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'Author can add award when create question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '.award' do
        fill_in 'Award title', with: 'My award'
        attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
    end
  end
end
