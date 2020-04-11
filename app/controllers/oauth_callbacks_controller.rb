# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  Devise.omniauth_configs.each_key { |service| define_method(service) {} }

  private

  def oauth
    user = User.find_for_oauth(request.env['omniauth.auth'])

    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Invalid credentials'
    end
  end
end
