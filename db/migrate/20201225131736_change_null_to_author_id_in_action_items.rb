class ChangeNullToAuthorIdInActionItems < ActiveRecord::Migration[6.0]
  def change
    change_column_null :action_items, :author_id, false
    add_foreign_key :action_items, :users, column: :author_id
    add_index :action_items, :author_id
  end
end
