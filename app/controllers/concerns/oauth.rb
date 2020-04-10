# frozen_string_literal: true

module Oauth
  extend ActiveSupport::Concern

  included do
    before_action :oauth
  end

  private

  def oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
