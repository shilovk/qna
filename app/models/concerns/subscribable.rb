# frozen_string_literal: true

module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, as: :subscribable, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user

    after_create -> { subscribe(user) }
  end

  def subscribe(subscriber)
    subscriptions.create!(user_id: subscriber.id)
  end

  def unsubscribe(subscriber)
    subscriptions.destroy_by(user_id: subscriber.id)
  end

  def subscribed?(subscriber)
    subscriptions.exists?(user_id: subscriber&.id)
  end
end
