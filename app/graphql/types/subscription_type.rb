# frozen_string_literal: true

module Types
  class SubscriptionType < BaseObject
    field :card_added, Types::CardType, null: false, description: 'A card was added'

    def card_added; end
  end
end
