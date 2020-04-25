# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'Returns true if question belongs to user' do
      expect(author).to be_author(question)
    end

    it 'Returns false if question does not belongs to user' do
      expect(user).to_not be_author(question)
    end
  end

  context 'subscriptions' do
    let!(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:subscription) { user.subscribe!(question) }

    describe '#subscribe!' do
      it 'creates subscription' do
        expect { user.subscribe!(question) }.to change(Subscription, :count).by(1)
      end

      it 'attributes must match' do
        expect(subscription.user).to eq user
        expect(subscription.question).to eq question
      end
    end

    describe '#unsubscribe!' do
      let!(:subscription) { user.subscribe!(question) }

      it 'removes subscription' do
        expect { user.unsubscribe!(question) }.to change(Subscription, :count).by(-1)
      end

      it 'deleted subscription not exists' do
        expect { user.unsubscribe!(question) }.to change(Subscription.where(question: question, user: user), :empty?).from(false).to(true)
      end
    end

    describe '#subscribed?' do
      let!(:subscription) { user.subscribe!(question) }
      let(:other_question) { create(:question) }

      it 'user have subscription' do
        expect(user).to be_subscribed(question)
      end

      it 'user has not subscription to other question' do
        expect(user).to_not be_subscribed(other_question)
      end
    end

    describe '#subscription' do
      let!(:subscription) { user.subscribe!(question) }

      it 'returns subscription' do
        expect(user.subscription(question)).to eq subscription
      end
    end
  end
end
