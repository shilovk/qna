# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in with Oauth' do
  context 'sign in' do
    background { visit new_user_session_path }

    scenario 'with Facebook' do
      oauth_facebook
      expect(page).to have_content 'Sign in with Facebook'

      click_on 'Sign in with Facebook'

      expect(page).to have_content 'facebook@test.com'
      expect(page).to have_content 'Log out'
    end

    scenario 'with GitHub' do
      oauth_github
      expect(page).to have_content 'Sign in with GitHub'

      click_on 'Sign in with GitHub'

      expect(page).to have_content 'github@test.com'
      expect(page).to have_content 'Log out'
    end

    scenario 'have handle authentication error' do
       OmniAuth.config.mock_auth[:github] = :invalid_credentials

       click_link 'Sign in with GitHub'

       expect(page).to have_content('Invalid credentials')
     end
  end
end
