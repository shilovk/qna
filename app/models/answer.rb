# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
