# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    question
    user
    title
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb')) }
  end
end
