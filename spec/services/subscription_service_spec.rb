# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionService do
  describe 'Question\'s subscription service' do
    let!(:question) { create(:question, user: create(:user)) }
    let!(:answer) { create(:answer, question: question) }

    it 'sends question new answer for subscribers' do
      question.subscribers.find_each(batch_size: 500) do |user|
        expect(SubscriptionMailer).to receive(:question_new_answer).with(answer, user).and_call_original
      end

      subject.question_new_answer(answer)
    end

    context 'does not send question new answer' do
      let!(:unsubscriber) { create(:user) }
      let!(:other_subscriber) { create(:user, subscriptions: [create(:subscription)]) }
      let(:mailer) { double('SubscriptionMailer') }

      it 'to unsubscriber user' do
        expect(mailer).to_not receive(:question_new_answer).with(answer, unsubscriber)

        subject.question_new_answer(answer)
      end

      it 'to other subscriber' do
        expect(mailer).to_not receive(:question_new_answer).with(answer, other_subscriber)

        subject.question_new_answer(answer)
      end
    end
  end
end
