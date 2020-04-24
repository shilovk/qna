# frozen_string_literal: true

class SubscriptionQuestionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SubscriptionService.new.question_new_answer(answer)
  end
end
