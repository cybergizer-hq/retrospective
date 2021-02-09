# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def subscribed
    params.deep_transform_keys!(&:underscore)
    board = Board.find_by(slug: params[:board_slug])

    return reject unless board

    stream_for board
  end

  def unsubscribed
    stop_all_streams
  end
end
