# frozen_string_literal: true

class CreatePermissionsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions_users do |t|
      t.belongs_to :user
      t.belongs_to :permission
      t.belongs_to :board

      t.timestamps
    end
  end
end
