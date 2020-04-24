# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/question_new_answer
  def question_new_answer
    SubscriptionMailer.question_new_answer
  end
end
