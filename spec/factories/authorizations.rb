# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    user
    provider { "MyString" }
    uid { "MyString" }
  end
end
