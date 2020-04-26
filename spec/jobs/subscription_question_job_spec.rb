# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionQuestionJob, type: :job do
  let(:answer) { create(:answer) }
  let(:service) { double('SubscriptionService') }

  before do
    allow(SubscriptionService).to receive(:new).and_return(service)
  end

  it 'calls SubscriptionService#question_new_answer' do
    expect(service).to receive(:question_new_answer).with(answer)

    SubscriptionQuestionJob.perform_now(answer)
  end
end
