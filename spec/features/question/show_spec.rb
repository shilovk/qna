# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the questions and answers to it', "
  In order to get answer from a community
  As an authenticated and unauthenticated user
  I'd like to be able to view the question with it answers
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Authenticated user' do
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

  describe 'The best answer must be first' do
    background do
      sign_in(user)

      answers.last.set_best

      visit question_path(question)
    end

    scenario 'in answers list' do
      within '.answers > div:first' do
        expect(page).to have_content 'Best answer'
        expect(page).to have_content answers.last.body
      end
    end

    scenario 'after set the best answer', js: true do
      within find("#answer-#{answers.first.id}") do
        click_on 'Set the best'
      end

      visit question_path(question)

      within all('.answers > div').first do
        expect(page).to have_content 'Best answer'
        expect(page).to have_content answers.first.body
      end
    end
  end
end
