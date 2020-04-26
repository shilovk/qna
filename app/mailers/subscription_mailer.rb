# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  def question_new_answer(answer, user)
    @answer = answer
    @question = answer.question
    @user = user

    mail to: @user.email, subject: 'New Question\'s Answer'
  end
end
