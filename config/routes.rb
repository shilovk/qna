# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  mount ActionCable.server => '/cable'

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

    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  get :search, to: 'search#index'
end
