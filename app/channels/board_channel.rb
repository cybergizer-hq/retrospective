# frozen_string_literal: true

class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from board_channel
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    data = data.merge(id: membership_id) if data['front_action'] == 'update_status'

    ActionCable.server.broadcast(board_channel, data)
  end

  private

  def board_channel
    "board_#{params[:board]}"
  end

  def membership_id
    board = Board.find_by(slug: params[:board])
    Membership.find_by(user_id: current_user.id, board_id: board.id)&.id
  end
end
