# frozen_string_literal: true

require 'rails_helper'

feature 'User can create comment to the answer', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create a comment to the answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment to the answer with valid attributes', js: true do
      within "#answer-#{answer.id} .comments" do
        click_on class: 'add-comment-link'

        within '.comment-form' do
          fill_in id: 'comment_body', with: 'New comment'
          click_button ''
        end

        expect(page).to have_content 'New comment'
      end
    end

    scenario 'tries to create comment to the answer with invalid attributes', js: true do
      within "#answer-#{answer.id} .comments" do
        click_on class: 'add-comment-link'

        within '.comment-form' do
          fill_in id: 'comment_body', with: ''
          click_button ''
        end

        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  scenario 'Non-authenticated user tries to create comment to the answer' do
    visit question_path(question)

    within "#answer-#{answer.id} .comments" do
      expect(page).to_not have_link class: 'add-comment-link'
    end
  end

  context 'Multiple sessions to the answer\'s' do
    scenario 'comment appears on another user\'s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id} .comments" do
          click_on class: 'add-comment-link'

          within '.comment-form' do
            fill_in id: 'comment_body', with: 'New comment'
            click_button ''
          end

          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within "#answer-#{answer.id} .comments" do
          expect(page).to have_content 'New comment'
        end
      end
    end
  end
end
