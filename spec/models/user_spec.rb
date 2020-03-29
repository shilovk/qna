# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'def author?' do
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
end
