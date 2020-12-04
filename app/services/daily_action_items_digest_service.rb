# frozen_string_literal: true

class DailyActionItemsDigestService
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyActionItemsMailer.digest(user).deliver_later
    end
  end
end
