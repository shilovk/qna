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
      after :create do |question|
        question.files.attach({
              io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
              filename: 'rails_helper.rb'
        })
      end
    end

    trait :with_files do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb')), Rack::Test::UploadedFile.new(Rails.root.join('spec', 'spec_helper.rb'))] }
    end

    trait :with_award do
      award { create(:award) }
    end
  end
end
