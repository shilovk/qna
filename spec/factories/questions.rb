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

    trait :with_file do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'))] }
    end
  end
end
