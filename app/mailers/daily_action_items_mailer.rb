# frozen_string_literal: true

class DailyActionItemsMailer < ApplicationMailer
  def send_action_items(user, board)
    @action_items = user.action_items.where(board_id: board.id, status: 'pending')
    @board = board
    @greeting = "Good day, #{user.nickname}"

    return if @action_items.empty?

    mail to: user.email, subject: "It's your new action items!"
  end
end
