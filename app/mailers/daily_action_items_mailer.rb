# frozen_string_literal: true

class DailyActionItemsMailer < ApplicationMailer
  def digest(user)
    @action_items = user.action_items.where(status: 'pending').where('created_at > ?', 1.days.ago)
    @greeting = "Good day, #{user.nickname}"

    return if @action_items.empty?

    mail to: user.email, subject: "It's your new action items!"
  end
end
