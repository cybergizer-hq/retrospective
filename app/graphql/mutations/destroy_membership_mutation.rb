# frozen_string_literal: true

module Mutations
  class DestroyMembershipMutation < Mutations::BaseMutation
    argument :id, ID, required: true

    field :id, Int, null: true

    # rubocop:disable Metrics/MethodLength
    def resolve(id:)
      membership = Membership.find(id)
      authorize! membership, to: :destroy?,
                             context: { membership: Membership.find_by(user: context[:current_user],
                                                                       board: membership.board) }
      if membership.destroy
        PermissionsUser.where(board: membership.board, user: membership.user).destroy_all

        RetrospectiveSchema.subscriptions.trigger('membership_destroyed',
                                                  { board_slug: membership.board.slug },
                                                  id: id)
        { id: id }
      else
        { errors: { full_messages: membership.errors.full_messages } }
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
