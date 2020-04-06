# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :awards, only: :index
  resources :links, only: :destroy

  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
      post :up, on: :member
      post :down, on: :member
    end
  end
end
