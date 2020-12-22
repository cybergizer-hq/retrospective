# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    description { Faker::ChuckNorris.fact }
    identifier { Faker::Verb.unique.base }
  end
end
