# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association :user
    association :question
    body { 'MyAnswer' }

    trait :invalid do
      body { nil }
    end
  end
end
