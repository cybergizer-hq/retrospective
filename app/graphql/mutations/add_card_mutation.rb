# frozen_string_literal: true

module Mutations
  class AddCardMutation < Mutations::BaseMutation
    argument :attributes, Types::CardAttributes, required: true

    field :card, Types::CardType, null: true

    # rubocop:disable Metrics/MethodLength
    def resolve(attributes:)
      params = attributes.to_h
      board = Board.find_by!(slug: params.delete(:board_slug))
      authorize! board, to: :create_cards?, context: { user: context[:current_user], board: board }

      result = Boards::Cards::Create.new(current_user).call(card_params(params, board))

      if result.success?
        card = result.value!

        like_permission_id = Permission.where(identifier: 'like_card').ids.first

        board.users.each do |board_user|
          CardPermissionsUser.create(user: board_user, card: card, permission_id: like_permission_id)
        end

        RetrospectiveSchema.subscriptions.trigger('card_added', { board_slug: board.slug }, card)
        { card: card }
      else
        { errors: { full_messages: result.failure.message } }
      end
    end
    # rubocop:enable Metrics/MethodLength

    def card_params(params, board)
      params.merge(board: board, author: context[:current_user])
    end
  end
end
