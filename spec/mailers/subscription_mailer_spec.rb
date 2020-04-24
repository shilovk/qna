# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionMailer, type: :mailer do
  describe 'question_new_answer' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, question: create(:question)) }
    let(:mail) { SubscriptionMailer.question_new_answer(answer, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New Question\'s Answer')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.email)
      expect(mail.body.encoded).to match('New answer to the question')
      expect(mail.body.encoded).to match(answer.question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
