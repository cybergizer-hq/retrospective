module Mutations
  class DestroyCardMutation < Mutations::BaseMutation
    argument :id, ID, required: true

    field :card, Types::CardType, null: false
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(id:)
      card = Card.find(id)
      card.destroy!

      { card: card }
    end
  end
end
