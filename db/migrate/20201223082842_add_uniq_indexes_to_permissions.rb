# frozen_string_literal: true

class AddUniqIndexesToPermissions < ActiveRecord::Migration[6.0]
  def change
    add_index :permissions, :identifier, unique: true

    add_index :permissions_users,
              %i[permission_id user_id board_id],
              unique: true,
              name: 'index_permissions_users_on_user_board_permission'
  end
end
