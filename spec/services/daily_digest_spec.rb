# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigest do
  let(:users) { create_list(:user, 3) }

  context 'with new questions' do
    let!(:questions) { create_list(:question, 2, user: users.last) }

    it 'sends daily digest to all users' do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }

      subject.send_digest
    end
  end

  context 'without new questions' do
    let!(:questions) { create_list(:question, 2, created_at: 1.day.ago, user: users.last) }

    it 'does not sends daily digest to all users' do
      expect(DailyDigestMailer).to_not receive(:digest)

      subject.send_digest
    end
  end
end
