# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, as: :linkable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer&.update!(best: false)
      update!(best: true)
      question.award&.update!(user_id: user.id)
    end
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
