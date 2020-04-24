# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribable, polymorphic: true, optional: true

  validates :user, uniqueness: { scope: :subscribable_id }
end
