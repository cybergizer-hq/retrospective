# frozen_string_literal: true

class AddAuthorRefToActionItems < ActiveRecord::Migration[6.0]
  def up
    add_column :action_items, :author_id, :bigint
  end

  def down
    remove_reference :action_items, :author, foreign_key: { to_table: 'users' }
  end
end
