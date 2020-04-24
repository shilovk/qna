# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { create(:question) }

  it { should belong_to(:user) }
  it { should have_one(:award) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context 'subscriptions' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    describe '#subscribe(subscriber)' do
      let!(:subscription) { subject.subscribe(user) }

      it 'creates subscription' do
        expect { question.subscribe(user) }.to change(Subscription, :count).by(1)
      end

      it 'attributes must match' do
        expect(subscription.subscribable).to eq subject
        expect(subscription.user).to eq user
      end

      it 'add author to subscribers after create' do
        expect(subject.subscribers).to include(subject.user)
      end
    end

    describe '#unsubscribe(subscriber)' do
      let!(:subscription) { subject.subscribe(user) }

      it 'removes subscription' do
        expect { subject.unsubscribe(user) }.to change(Subscription, :count).by(-1)
      end

      it 'deletes subscription not exists' do
        expect { subject.unsubscribe(user) }.to change(Subscription.where(subscribable: subject, user: user), :empty?).from(false).to(true)
      end
    end

    describe '#subscribed?' do
      let!(:subscription) { subject.subscribe(user) }

      it 'user has subscription' do
        expect(subject).to be_subscribed(user)
      end

      it 'user has not subscription on other question' do
        expect(question).to_not be_subscribed(user)
      end
    end
  end
end
