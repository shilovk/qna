# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    member do
      post :up
      post :down
    end
  end

  resources :attachments, only: :destroy
  resources :awards, only: :index
  resources :links, only: :destroy

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :best, on: :member
    end
  end
end
