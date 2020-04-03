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

    trait :with_file do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'))] }
    end
  end
end
