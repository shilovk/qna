# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  default_scope { order('best DESC, created_at') }

  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  after_create_commit :notify_subscribers

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer&.update!(best: false)
      update!(best: true)
      question.award&.update!(user_id: user.id)
    end
  end

  private

  def notify_subscribers
    SubscriptionQuestionJob.perform_later(self)
  end
end
