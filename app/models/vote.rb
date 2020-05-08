# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true, touch: true

  validates :value, presence: true, inclusion: { in: [1, -1] }
end
