# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search in questions, answers, comments ans users', "
  In order to find needed information
  As a user
  I'd like to be able to search in questions, answers, comments and users
" do
  given(:scopes) { SearchService::AVAILABLE_RESOURCES }
  given!(:questions) { create_list(:question, 3) }
  given(:question) { questions.first }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:answer) { answers.first }
  given!(:comments) { create_list(:comment, 3, commentable: answer) }
  given(:comment) { comments.first }
  given!(:users) { create_list(:user, 3) }
  given(:user) { users.first }

  background { visit root_path }

  scenario 'Search both in questions, answers, comments, users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search form' do
        fill_in :search_query, with: 'body'
        select 'All', from: :search_scope
        click_on 'Search'
      end

      expect(page).to have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body

      within '.search form' do
        fill_in :search_query, with: user.email
        select 'All', from: :search_scope
        click_on 'Search'
      end

      expect(page).to have_content user.email
    end
  end

  describe 'Search only in questions', sphinx: true, js: true do
    given(:resources) { comments }
    given(:testing_field) { 'body' }

    it_behaves_like 'Search only in resource'
  end

  describe 'Search only in answers', sphinx: true, js: true do
    given(:resources) { answers }
    given(:testing_field) { 'body' }

    it_behaves_like 'Search only in resource'
  end

  describe 'Search only in comments', sphinx: true, js: true do
    given(:resources) { comments }
    given(:testing_field) { 'body' }

    it_behaves_like 'Search only in resource'
  end

  describe 'Search only in users', sphinx: true, js: true do
    given(:resources) { users }
    given(:testing_field) { 'email' }

    it_behaves_like 'Search only in resource'
  end
end
