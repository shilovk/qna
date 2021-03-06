# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:new_questions) { create_list(:question, 5) }
    let(:old_questions) { create_list(:question, 3, created_at: 1.day.ago) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New Questions Digest')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      new_questions.pluck(:title).each do |question|
        expect(mail.body.encoded).to match(question)
      end

      old_questions.pluck(:title).each do |question|
        expect(mail.body.encoded).to_not match(question)
      end
    end
  end
end
