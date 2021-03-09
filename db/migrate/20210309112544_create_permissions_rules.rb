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
    end

    board_permissions_rules_data = []
    BoardPermissionsUser.find_each do |record|
      board_permissions_rules_data << {
        user_id: record.user.id,
        permission_id: record.permission.id,
        permissionable_type: 'Board',
        permissionable_id: record.board.id,
        created_at: record.created_at,
        updated_at: record.updated_at
      }
    end
    PermissionsRule.insert_all!(board_permissions_rules_data) if board_permissions_rules_data.any?

    card_permissions_rules_data = []
    CardPermissionsUser.find_each do |record|
      card_permissions_rules_data << {
        user_id: record.user.id,
        permission_id: record.permission.id,
        permissionable_type: 'Card',
        permissionable_id: record.card.id,
        created_at: record.created_at,
        updated_at: record.updated_at
      }
    end
    PermissionsRule.insert_all!(card_permissions_rules_data) if card_permissions_rules_data.any?

    comment_permissions_rules_data = []
    CommentPermissionsUser.find_each do |record|
      comment_permissions_rules_data << {
        user_id: record.user.id,
        permission_id: record.permission.id,
        permissionable_type: 'Comment',
        permissionable_id: record.comment.id,
        created_at: record.created_at,
        updated_at: record.updated_at
      }
    end
    PermissionsRule.insert_all!(comment_permissions_rules_data) if comment_permissions_rules_data.any?
  end

  def down
    drop_table :permissions_rules
  end
end
