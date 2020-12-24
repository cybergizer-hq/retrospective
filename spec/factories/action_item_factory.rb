# frozen_string_literal: true

FactoryBot.define do
  factory :action_item do
    sequence(:body) { |n| "Test Action Item#{n}" }
    association :board
    association :assignee, factory: :user
    association :author, factory: :user, email: Faker::Internet.email
  end
end
