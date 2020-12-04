# frozen_string_literal: true

class DailyActionItemsService
  def send_mails(board)
    board.users.find_each(batch_size: 500) do |user|
      DailyActionItemsMailer.send_action_items(user, board).deliver_later
    end
  end
end
