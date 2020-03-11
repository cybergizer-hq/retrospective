module Mutations
  class AddCardMutation < Mutations::BaseMutation
    argument :attributes, Types::CardAttributes, required: true

    field :card, Types::CardType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(attributes:)
      card = Card.new(attributes.to_h)

      if card.save
        RetrospectiveSchema.subscriptions.trigger('card_added', {}, card)
        { card: card }
      else
        { errors: card.errors.full_messages }
      end
    end
  end
end
