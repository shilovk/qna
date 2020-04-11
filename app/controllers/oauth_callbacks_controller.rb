# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  include Oauth

  Devise.omniauth_configs.each_key { |service| define_method(service) {} }
end
