# frozen_string_literal: true

class SubscriptionService
  def question_new_answer(answer)
    users = answer.question.subscribers

    users.find_each(batch_size: 500) do |user|
      SubscriptionMailer.question_new_answer(answer, user).deliver_later
    end
  end
end
