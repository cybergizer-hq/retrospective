# frozen_string_literal: true

class CreatePermissionsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions_users do |t|
      t.belongs_to :user
      t.belongs_to :permission
      t.belongs_to :board

      t.index %i[permission_id user_id board_id],
              unique: true,
              name: 'index_permissions_users_on_user_board_permission'

      t.timestamps
    end
  end
end
