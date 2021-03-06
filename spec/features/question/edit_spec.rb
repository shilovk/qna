# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to edit a question
  As an authenticated user
  I'd like to be able to edit my own question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }
  given(:url) { 'http://foo.com' }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: ''
        click_on 'Save question'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'edits his question with attached files', js: true do
      within '.question' do
        click_on 'Edit question'
        attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save question'

        expect(page).to_not have_selector "input[multiple='multiple'][type='file']"
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'deletes file on his question', js: true do
      page.accept_confirm do
        click_on 'Remove file'
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_content question.files.first
    end

    scenario 'edits his question with added links', js: true do
      within '.question' do
        click_on 'Edit question'

        click_on 'Add link'

        fill_in 'Link name', with: 'My url'
        fill_in 'Url', with: url

        click_on 'Save question'

        expect(page).to have_link 'My url', href: url
      end
    end

    scenario 'deletes link on his question', js: true do
      create(:link, linkable: question)
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'

        within '.nested-fields' do
          click_on 'Remove link'
        end

        expect(page).to_not have_content question.links.first
      end
    end
  end

  describe 'Authenticated user that not author of question' do
    given!(:link) { create(:link, linkable: question) }

    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'tries to edit question', js: true do
      within '.question' do
        expect(page).to_not have_link 'Edit question'
      end
    end

    scenario 'tries to delete file on question' do
      within '.question' do
        expect(page).to_not have_link 'Remove file'
      end
    end

    scenario 'tries to delete link on another question' do
      within '.question' do
        expect(page).to_not have_link 'Edit question'
        expect(page).to_not have_link 'Remove link'
      end
    end
  end
end
