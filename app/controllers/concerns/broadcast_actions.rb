# frozen_string_literal: true

module BroadcastActions
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/LineLength
  def broadcast_card(action_name, slug, resource)
    ActionCable.server.broadcast "board_#{slug}",
                                 front_action: action_name,
                                 card: ActiveModelSerializers::SerializableResource.new(resource).as_json
  end
  # rubocop:enable Metrics/LineLength

  def broadcast_membership(action_name, slug, membership)
    ActionCable.server.broadcast "board_#{slug}",
                                 front_action: action_name,
                                 id: membership.id
  end

  # rubocop:disable Metrics/LineLength
  def broadcast_all_memberships(board)
    ActionCable.server.broadcast "board_#{board.slug}",
                                 front_action: 'add_users',
                                 memberships: ActiveModelSerializers::SerializableResource.new(board.memberships,
                                                                                               each_serializer: MembershipSerializer).as_json
  end
  # rubocop:enable Metrics/LineLength
end
