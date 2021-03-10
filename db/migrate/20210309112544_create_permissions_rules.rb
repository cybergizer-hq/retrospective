# frozen_string_literal: true

class CreatePermissionsRules < ActiveRecord::Migration[6.1]
  def up
    create_table :permissions_rules do |t|
      t.belongs_to :user
      t.belongs_to :permission
      t.references :permissionable, polymorphic: true

      t.index %i[permission_id user_id permissionable_id permissionable_type],
              unique: true,
              name: 'index_permissions_rules_on_user_permissionable_permission'

      t.timestamps

      rewrite_board_permissions if Board.any?
      rewrite_card_permissions if Card.any?
      rewrite_comment_permissions if Comment.any?
    end
  end

  def down
    drop_table :permissions_rules
  end

  def build_data(record)
    {
      user_id: record.user.id,
      permission_id: record.permission.id,
      permissionable_type: record.class.to_s,
      permissionable_id: record.board.id,
      created_at: record.created_at,
      updated_at: record.updated_at
    }
  end

  def rewrite_board_permissions
    permissions_rules_data = []

    BoardPermissionsUser.find_each do |record|
      permissions_rules_data << build_data(record)
    end

    PermissionsRule.insert_all!(permissions_rules_data)
  end

  def rewrite_card_permissions
    permissions_rules_data = []

    CardPermissionsUser.find_each do |record|
      permissions_rules_data << build_data(record)
    end

    PermissionsRule.insert_all!(permissions_rules_data)
  end

  def rewrite_comment_permissions
    permissions_rules_data = []

    CommentPermissionsUser.find_each do |record|
      permissions_rules_data << build_data(record)
    end

    PermissionsRule.insert_all!(permissions_rules_data)
  end
end
