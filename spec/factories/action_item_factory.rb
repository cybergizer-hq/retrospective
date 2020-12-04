# frozen_string_literal: true

FactoryBot.define do
  factory :action_item do
    sequence(:body) { |n| "Test Action Item#{n}" }
    association :board
    association :assignee, factory: :user
  end
end
