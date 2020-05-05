# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@shilovk.ru'
  layout 'mailer'
end
