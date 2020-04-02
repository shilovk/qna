# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    user
    title
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end
  end
end
