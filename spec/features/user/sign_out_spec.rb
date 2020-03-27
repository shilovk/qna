# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  In order to log out
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'Registered user сan to sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
