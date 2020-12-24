# frozen_string_literal: true

class AddAuthorRefToActionItems < ActiveRecord::Migration[6.0]
  def up
    add_reference :action_items, :author, foreign_key: { to_table: 'users' }

    Board.find_each do |board|
      creator = board.memberships.where(role: 'creator').first
      board.action_items.update_all(author_id: creator.user_id)
    end
  end

  def down
    remove_reference :action_items, :author, foreign_key: { to_table: 'users' }
  end
end
