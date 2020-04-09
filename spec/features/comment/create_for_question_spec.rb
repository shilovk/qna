# frozen_string_literal: true

require 'rails_helper'

feature 'User can create comment to question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create a comment for the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for the question with valid attributes', js: true do
      click_on class: 'add-comment-link'
      within '.question .comments form.comment-form' do
        fill_in id: 'comment_body', with: 'New comment'
        click_button ''
        expect(page).to have_content 'New comment'
      end
    end

    scenario 'tries to create comment for the question with invalid attributes', js: true do
      click_on class: 'add-comment-link'
      within '.question .comments form.comment-form' do
        fill_in id: 'comment_body', with: ''
        click_button ''
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  scenario 'Non-authenticated user tries to create comment for the question' do
    visit question_path(question)

    within '.question .comments' do
      expect(page).to_not have_link class: 'add-comment-link'
    end
  end

  context 'Multiple sessions' do
    scenario 'comment appears on another user\'s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on class: 'add-comment-link'
        within '.question .comments form.comment-form' do
          fill_in id: 'comment_body', with: 'New comment'
          click_button ''
          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question .comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
  end
end
