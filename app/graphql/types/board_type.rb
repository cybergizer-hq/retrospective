# frozen_string_literal: true

module Types
  class BoardType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :slug, String, null: false
    field :cards, [Types::CardType], null: false
    field :memberships, [Types::MembershipType], null: false
    field :current_membership, Types::MembershipType, null: false
    field :action_items, [Types::ActionItemType], null: false
    field :previous_action_items, [Types::ActionItemType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def previous_action_items
      object.previous_board.action_items if object.previous_board&.action_items&.any?
    end

    def current_membership
      object.memberships.find_by(user: context[:current_user])
    end
  end
end
