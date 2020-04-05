require 'rails_helper'

feature 'Authenticated user can see list of his awards', "
  In order to see earned awards on answers
  As an authenticated user
  I'd like to be able to see list of my awards
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:awards) { create_list(:award, 3, question: question, user: user) }

  background do
    visit new_user_session_path
    sign_in(user)
  end

  scenario 'Authenticated user views his awards list' do
    visit awards_path

    awards.each do |award|
      expect(page).to have_content award.title
      expect(page).to have_content award.question.title
    end
  end
end
