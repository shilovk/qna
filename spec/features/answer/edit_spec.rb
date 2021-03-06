# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer', "
  In order to edit an answer for the question
  As an authenticated user
  I'd like to be able to edit my own answer for the question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }
  given(:url) { 'http://foo.com' }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do
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

    scenario 'edits his answer with attached files', js: true do
      within ".answers #answer-#{answer.id}" do
        click_on 'Edit answer'

        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'deletes file on his answer', js: true do
      page.accept_confirm do
        click_on 'Remove file'
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_content answer.files.first
    end

    scenario 'edits his answer with added links', js: true do
      within ".answers #answer-#{answer.id}" do
        click_on 'Edit answer'

        click_on 'Add link'

        fill_in 'Link name', with: 'My url'
        fill_in 'Url', with: url

        click_on 'Save answer'

        expect(page).to have_link 'My url', href: url
      end
    end

    scenario 'deletes link on his answer', js: true do
      create(:link, linkable: answer)
      visit question_path(question)

      within ".answers #answer-#{answer.id}" do
        click_on 'Edit answer'

        within '.nested-fields' do
          click_on 'Remove link'
        end

        expect(page).to_not have_content answer.links.first
      end
    end
  end

  describe 'Authenticated user that not author of answer' do
    given!(:link) { create(:link, linkable: answer) }

    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'tries to edit answer', js: true do
      within '.answers' do
        expect(page).to_not have_link 'Edit answer'
      end
    end

    scenario 'tries to delete file on answer' do
      within '.answers' do
        expect(page).to_not have_link 'Remove file'
      end
    end

    scenario 'tries to delete link on another answer' do
      within '.answers' do
        expect(page).to_not have_link 'Edit answer'
        expect(page).to_not have_link 'Remove link'
      end
    end
  end
end
