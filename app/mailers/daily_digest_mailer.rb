# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user, date)
    @user = user
    @questions =  Question.after_date(date)
    mail to: @user.email, subject: 'New Questions Digest'
  end
end
