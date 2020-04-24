# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :subscribable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: :subscribable_id }
end
