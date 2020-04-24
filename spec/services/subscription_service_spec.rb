# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionService do
  describe 'Question\'s subscription service' do
    let!(:question) { create(:question, user: create(:user)) }
    let!(:answer) { create(:answer, question: question) }

    context 'for question\'s author' do
      # let(:subscription) { question.subscriptions.find_by(user_id: question.user_id).include(:user) }

      it 'sends question new answer by subscription' do
        expect(SubscriptionMailer).to receive(:question_new_answer).with(answer, question.user).and_call_original

        subject.question_new_answer(answer)
      end
    end

    # context 'for subscriber' do
    #   let!(:subscriber) { create(:user) }
    #   let!(:subscription) { create(:subscription, user: subscribed_user, question: question) }
    #   let!(:unsubscriber) { create(:user) }
    # end
  end
end
