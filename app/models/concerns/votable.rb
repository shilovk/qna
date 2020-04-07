# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def score
    votes.sum(:value)
  end

  def vote_up
    return if votes.find_by(value: -1, user_id: user.id)&.delete

    votes.find_or_create_by!(value: 1, user_id: user.id)
  end

  def vote_down
    return if votes.find_by(value: 1, user_id: user.id)&.delete

    votes.find_or_create_by!(value: -1, user_id: user.id)
  end
end
