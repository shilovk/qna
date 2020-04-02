# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "MyAnswer#{n}"
  end

  factory :answer do
    user
    question
    body

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
