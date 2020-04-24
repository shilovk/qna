# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.after_date(1.day.ago)
    mail to: @user.email, subject: 'New Questions Digest'
  end
end
