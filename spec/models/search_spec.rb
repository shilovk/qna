# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should validate_length_of(:query).is_at_least(3) }
end
