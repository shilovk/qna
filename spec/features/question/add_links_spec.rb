# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  describe 'User adds link when asks a question' do
    given(:user) { create(:user) }
    given(:url) { 'http://foo.com' }
    given(:gist_url) { 'https://gist.github.com/shilovk/71e74ced60a35be63b74510b1cf13d94' }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'with valid url' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My url'
      fill_in 'Url', with: url

      click_on 'Ask'

      within('.question') do
        expect(page).to have_link 'My url', href: url
        expect(page).to_not have_selector :css, 'script', visible: false, minimum: 1
      end
    end

    scenario 'with invalid url' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My url'
      fill_in 'Url', with: 'foo'

      click_on 'Ask'

      expect(page).to have_content 'is not a valid URL'
      expect(page).to_not have_link 'My url', href: 'foo'
    end

    scenario 'with valid gist url' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      within('.question') do
        expect(page).to have_selector :css, 'script', visible: false, minimum: 1
        expect(page).to_not have_link 'My gist', href: gist_url
      end
    end
  end
end
