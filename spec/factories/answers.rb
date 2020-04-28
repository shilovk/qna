# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer's body #{n}"
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

    trait :with_files do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb')), Rack::Test::UploadedFile.new(Rails.root.join('spec', 'spec_helper.rb'))] }
    end

    trait :with_links do
      after :create do |resource|
        resource.links.push create_list(:link, 2, linkable: resource)
      end
    end

    trait :with_comments do
      after :create do |resource|
        resource.comments.push create_list(:comment, 3, commentable: resource)
      end
    end
  end
end
