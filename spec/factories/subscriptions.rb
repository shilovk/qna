# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user

    trait :for_question do
      subscribable { create(:question) }
    end
  end
end
