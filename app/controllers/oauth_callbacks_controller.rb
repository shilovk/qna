# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  include Oauth

  Devise.omniauth_configs.keys.each { |service| define_method(service) {} }
end
