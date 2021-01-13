# frozen_string_literal: true

class PopulateAuthorIdToActionItems < ActiveRecord::Migration[6.0]
  def change
    Board.find_each do |board|
      creator = board.memberships.where(role: 'creator').first
      if creator
        board.action_items.update_all(author_id: creator.user_id)
      else
        c = board.memberships.first
        c.update(role: 'creator')
        board.action_items.update_all(author_id: c.user_id)
      end
    end
  end
end
