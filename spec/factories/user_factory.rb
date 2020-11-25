# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:nickname) { |n| "user_nick#{n}" }
    password { 'password' }
    password_confirmation { 'password' }
    first_name { 'Name' }
    last_name { 'Surname' }

    trait :github do
      provider { 'github' }
      uid { 1234 }
    end
  end
end
