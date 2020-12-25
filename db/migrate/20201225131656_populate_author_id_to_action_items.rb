class PopulateAuthorIdToActionItems < ActiveRecord::Migration[6.0]
  def change
    Board.find_each do |board|
      creator = board.memberships.where(role: 'creator').first
      board.action_items.update_all(author_id: creator.user_id)
    end
  end
end
