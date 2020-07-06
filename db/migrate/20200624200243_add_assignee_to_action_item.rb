# frozen_string_literal: true

class AddAssigneeToActionItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :action_items, :assignee, foreign_key: { to_table: 'users' }
  end
end
