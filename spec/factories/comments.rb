# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user
    sequence(:body) { |n| "Comment's body #{n}" }
  end

  factory :invalid_comment, class: 'Comment' do
    user
    body { nil }
  end
end
