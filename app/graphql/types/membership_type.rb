# frozen_string_literal: true

module Types
  class MembershipType < Types::BaseObject
    field :id, Int, null: false
    field :role, String, null: false
    field :ready, Boolean, null: false
    field :user, Types::UserType, null: false
    field :board_id, Int, null: false
  end
end
