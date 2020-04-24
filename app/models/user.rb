# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: Devise.omniauth_configs.keys

  has_many :questions
  has_many :answers
  has_many :awards, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call if auth
  end

  def author?(record)
    id == record&.user_id
  end

  # def subscribe!(resource)
  #   return if subscribed?(resource)
  #
  #   subscriptions.create!(subscribable: resource)
  # end
  #
  # def unsubscribe!(resource)
  #   return unless subscribed?(resource)
  #
  #   subscriptions.destroy_by(subscribable: resource)
  # end

  # def subscribed?(resource)
  #   subscriptions.exists?(subscribable: resource)
  # end
end
