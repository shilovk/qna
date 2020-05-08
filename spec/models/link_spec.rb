# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).touch(true) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_values('http://foo.com', 'https://foo.com').for(:url) }
  it { should_not allow_values('foo', 'buz').for(:url) }
end
