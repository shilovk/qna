# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question, Answer, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:question) { create(:question, :with_file, user_id: user.id) }
    let(:answer) { create(:answer, :with_file, user_id: user.id) }
    let(:comment) { create(:comment, user_id: user.id) }
    let(:link_for_question) { create(:link, linkable: question) }
    let(:link_for_answer) { create(:link, linkable: answer) }
    let(:subscription) { create(:subscription, :for_question, user_id: user.id) }

    let(:other_question) { create(:question, :with_file, user_id: other_user.id) }
    let(:other_answer) { create(:answer, :with_file, user_id: other_user.id) }
    let(:other_comment) { create(:comment, user_id: other_user.id) }
    let(:other_link_for_question) { create(:link, linkable: other_question) }
    let(:other_link_for_answer) { create(:link, linkable: other_answer) }
    let(:other_subscription) { create(:subscription, :for_question, user_id: user.id) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question, Answer, Comment, Link, Award }

    it {
      should be_able_to %i[update destroy],
                        question,
                        answer,
                        comment,
                        question.files.first,
                        question.links.first,
                        answer.files.first,
                        answer.links.first
    }

    it {
      should_not be_able_to %i[update destroy],
                            other_question, other_answer,
                            other_comment,
                            other_question.files.first,
                            other_answer.files.first,
                            other_question.links.first,
                            other_answer.links.first
    }

    it { should be_able_to %i[subscribe unsubscribe], question }

    it { should be_able_to %i[up down], other_question, other_answer }
    it { should_not be_able_to %i[up down], question, answer }

    describe 'best answer' do
      let(:answer_to_own_question) { create(:answer, question: question) }
      let(:answer_to_not_own_question) { build(:answer, question: other_question) }

      it { should be_able_to :best, answer_to_own_question }
      it { should_not be_able_to :best, answer_to_not_own_question }
    end
  end
end
