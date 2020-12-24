# frozen_string_literal: true

module Mutations
  class AddActionItemMutation < Mutations::BaseMutation
    argument :attributes, Types::ActionItemAttributes, required: true

    field :action_item, Types::ActionItemType, null: true

    # rubocop:disable Metrics/MethodLength
    def resolve(attributes:)
      params = attributes.to_h
      board = Board.find_by!(slug: params.delete(:board_slug))
      action_item = ActionItem.new(item_params(params, board))
      authorize! action_item, to: :create?, context: { user: context[:current_user], board: board }
      if action_item.save
        RetrospectiveSchema.subscriptions.trigger('action_item_added', { board_slug: board.slug },
                                                  action_item)
        { action_item: action_item }
      else
        { errors: { full_messages: action_item.errors.full_messages } }
      end
    end
    # rubocop:enable Metrics/MethodLength

    def item_params(params, board)
      params.merge(board: board, author: context[:current_user])
    end
  end
end
