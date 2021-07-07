# frozen_string_literal: true

module Mutations
  class DestroyMembershipMutation < Mutations::BaseMutation
    argument :id, ID, required: true

    field :id, Int, null: true

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def resolve(id:)
      membership = Membership.find(id)
      authorize! membership, to: :destroy?,
                             context: { membership: Membership.find_by(user: context[:current_user],
                                                                       board: membership.board) }

      membership.transaction do
        membership.board.permissions_rules.where(user: membership.user).destroy_all
        membership.destroy
      end

      if !membership.persisted?
        RetrospectiveSchema.subscriptions.trigger('membership_destroyed',
                                                  { board_slug: membership.board.slug },
                                                  id: id)
        { id: id }
      else
        { errors: { full_messages: membership.errors.full_messages } }
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
