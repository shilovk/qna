# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :commentable do
    resources :comments, only: %i[create update destroy], shallow: true
  end

  concern :votable do
    member do
      post :up
      post :down
    end
  end

  resources :attachments, only: :destroy
  resources :awards, only: :index
  resources :links, only: :destroy

  resources :questions, concerns: %i[commentable votable] do
    resources :answers, shallow: true, concerns: %i[commentable votable], except: %i[index new] do
      patch :best, on: :member
    end
  end
end
