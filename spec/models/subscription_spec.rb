# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { create(:subscription, :for_question) }

  it { should belong_to(:user) }
  it { should belong_to(:subscribable).optional }

  it { should validate_uniqueness_of(:user).scoped_to(:subscribable_id) }
end
