# frozen_string_literal: true

require 'rails_helper'

feature 'User can get list of questions', "
  In order to get answer from a community
  As an authenticated and unauthenticated user
  I'd like to be able to view questions list
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'views questions list' do
      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end

  scenario 'Unauthenticated user views questions list' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
