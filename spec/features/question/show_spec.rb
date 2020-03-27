# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the questions and answers to it', "
  In order to get answer from a community
  As an authenticated and unauthenticated user
  I'd like to be able to view the question with it answers
" do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'views question with it answers' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end

  scenario 'Unauthenticated user views question with it answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
