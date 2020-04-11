# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user
    votable
    value { 0 }
  end
end
