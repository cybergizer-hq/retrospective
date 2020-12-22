# frozen_string_literal: true

FactoryBot.define do
  factory :permissions_user do
    user
    permission
    board
  end
end
