# frozen_string_literal: true

class DailyActionItemsJob < ApplicationJob
  queue_as :default

  def perform(board)
    DailyActionItemsService.new.send_mails(board)
  end
end
