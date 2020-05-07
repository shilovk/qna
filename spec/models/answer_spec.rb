# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).touch(true) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#set_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, :with_award, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_answer) { create(:answer, :best, question: question, user: user) }
    before { answer.set_best }

    it 'should choose answer as the best' do
      expect(answer).to be_best
    end

    it "should set question's award to user" do
      expect(user.awards.map(&:id)).to include(question.award.id)
    end

    it 'should desable best for old answer' do
      expect(answer).to be_best
      other_answer.reload
      expect(other_answer).to_not be_best
    end

    it 'have many attached file' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    it 'perform SubscriptionQuestionJob' do
      expect(SubscriptionQuestionJob).to receive(:perform_later).with(instance_of(Answer))

      create(:answer)
    end
  end
end
