# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to get an authenticated user
  As an unregistered user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  describe 'Unregistered user' do
    scenario 'sign up successfully' do
      new_user = User.new(email: 'newuser@test.com', password: '12345678', password_confirmation: '12345678')
      sign_up(new_user)

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'sign up with invalid errors' do
      new_user = User.new(email: '', password: '1', password_confirmation: '')
      sign_up(new_user)

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password Password is too short (minimum is 6 characters)"
      expect(page).to have_content "Password confirmation doesn't match"
    end
  end

  scenario 'Registered user sign up' do
    sign_up(user)

    expect(page).to have_content 'Email has already been taken'
  end
end
