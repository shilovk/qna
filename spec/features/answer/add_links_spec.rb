# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  describe 'User adds link when asks an answer' do
    given(:user) { create(:user) }
    given!(:question) { create(:question) }
    given(:gist_url) { 'https://gist.github.com/shilovk/71e74ced60a35be63b74510b1cf13d94' }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid url', js: true do
      fill_in 'Your answer', with: 'My answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'with invalid url', js: true do
      fill_in 'Your answer', with: 'My answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'foo'

      click_on 'Create'

      expect(page).to have_content 'is not a valid URL'
    end
  end
end
