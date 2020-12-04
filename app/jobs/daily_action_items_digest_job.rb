# frozen_string_literal: true

class DailyActionItemsDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyActionItemsDigestService.new.send_digest
  end
end
