# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.find_or_create_by(email: 'tu1@mail.com') { |u| u.password = '123456', u.nickname = 'tu1', u.provider = 'provider', u.uid = 'uid1', u.last_name = 'Sidorov', u.first_name = 'Ivan' }
user2 = User.find_or_create_by(email: 'tu2@mail.com') { |u| u.password = '123456', u.nickname = 'tu2', u.provider = 'provider', u.uid = 'uid2', u.last_name = 'Petrov', u.first_name = 'Petr' }
user3 = User.find_or_create_by(email: 'tu3@mail.com') { |u| u.password = '123456', u.nickname = 'tu3', u.provider = 'provider', u.uid = 'uid3', u.last_name = 'Ivanov', u.first_name = 'Andrey' }
user4 = User.find_or_create_by(email: 'tu4@mail.com') { |u| u.password = '123456', u.nickname = 'tu4', u.provider = 'provider', u.uid = 'uid4', u.last_name = 'Abramov', u.first_name = 'Dmitriy' }
user5 = User.find_or_create_by(email: 'tu5@mail.com') { |u| u.password = '123456', u.nickname = 'tu5', u.provider = 'provider', u.uid = 'uid5', u.last_name = 'Mokhov', u.first_name = 'Fedor' }
user6 = User.find_or_create_by(email: 'tu6@mail.com') { |u| u.password = '123456', u.nickname = 'tu6', u.provider = 'provider', u.uid = 'uid6', u.last_name = 'Sidorova', u.first_name = 'Marina' }
user7 = User.find_or_create_by(email: 'tu7@mail.com') { |u| u.password = '123456', u.nickname = 'tu7', u.provider = 'provider', u.uid = 'uid7', u.last_name = 'Petrova', u.first_name = 'Anna' }
user8 = User.find_or_create_by(email: 'tu8@mail.com') { |u| u.password = '123456', u.nickname = 'tu8', u.provider = 'provider', u.uid = 'uid8', u.last_name = 'Ivanova', u.first_name = 'Sveta' }
user9 = User.find_or_create_by(email: 'tu9@mail.com') { |u| u.password = '123456', u.nickname = 'tu9', u.provider = 'provider', u.uid = 'uid9', u.last_name = 'Mokhova', u.first_name = 'Lyubov' }

Team.create(name: 'Wolves', user_ids: [user1.id, user2.id, user3.id, user4.id, user5.id]) unless Team.where(name: 'Wolves').exists?
Team.create(name: 'Tigers', user_ids: [user1.id, user5.id]) unless Team.where(name: 'Tigers').exists?
Team.create(name: 'Eagles', user_ids: [user2.id, user3.id, user4.id]) unless Team.where(name: 'Eagles').exists?

board1 = Board.find_or_create_by(title: 'TestUser1_RetroBoard')
board2 = Board.find_or_create_by(title: 'TestUser2_RetroBoard')
board3 = Board.find_or_create_by(title: 'TestUser3_RetroBoard')
board4 = Board.find_or_create_by(title: 'TestUser4_RetroBoard')
board5 = Board.find_or_create_by(title: 'TestUser5_RetroBoard')

Membership.create([
                    { user_id: user1.id, board_id: board1.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user3.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user4.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user5.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user6.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user7.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user8.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user9.id, board_id: board1.id, role: 'member', ready: false },
                    { user_id: user2.id, board_id: board2.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board3.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board4.id, role: 'creator', ready: false },
                    { user_id: user2.id, board_id: board5.id, role: 'creator', ready: false }
                  ])

permissions_data = {
  view_private_board: 'User can view private board',
  create_cards: 'User can create cards on board',
  create_comments: 'User can create comments on board',
  edit_board: 'User can edit board',
  update_board: 'User can update board',
  destroy_board: 'User can destroy board',
  continue_board: 'User can continue previous board',
  invite_members: 'User can invite members to board',
  get_suggestions: 'User can get tips with info',
  toggle_ready_status: 'User can toggle ready status of board membership',
  destroy_membership: 'User can destroy membership of board',
  destroy_any_card: 'User can delete any card on a board',
  destroy_card: 'User can delete a card on a board',
  update_card: 'User can update a card on a board',
  like_card: 'User can like a card on a board',
  update_comment: 'User can update a card comment',
  destroy_comment: 'User can delete a card comment',
  like_comment: 'User can like a card comment',
  create_action_items: 'User can create action items on a board',
  update_action_items: 'User can destroy action items on a board',
  destroy_action_items: 'User can destroy action items on a board',
  move_action_items: 'User can move action items',
  close_action_items: 'User can close action items',
  complete_action_items: 'User can mark action items as complete',
  reopen_action_items: 'User can reopen action items'
}

errors = []

(Permission::CREATOR_IDENTIFIERS | Permission::MEMBER_IDENTIFIERS | Permission::CARD_IDENTIFIERS | Permission::COMMENT_IDENTIFIERS).each do |identifier|
  next if Permission.exists?(identifier: identifier)

  begin
    Permission.create!(identifier: identifier, description: permissions_data[identifier.to_sym])
  rescue StandardError => e
    errors << { identifier => e.message }
  end
end
puts errors

Permission.creator_permissions.each do |permission|
  PermissionsRule.create([
                           { user_id: user1.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user2.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board2.id },
                           { user_id: user2.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board3.id },
                           { user_id: user2.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board4.id },
                           { user_id: user2.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board5.id },
                         ])
end

Permission.member_permissions.each do |permission|
  PermissionsRule.create([
                           { user_id: user2.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user3.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user4.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user5.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user6.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user7.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user8.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id },
                           { user_id: user9.id, permission_id: permission.id, permissionable_type: 'Board', permissionable_id: board1.id }
                         ])
end

Card.create(kind: 'mad', body: 'user1 is very mad', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very mad').exists?
Card.create(kind: 'sad', body: 'user1 is very sad', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very sad').exists?
Card.create(kind: 'glad', body: 'user1 is very glad #1', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very glad #1').exists?
Card.create(kind: 'glad', body: 'user1 is very glad #2', author_id: user1.id, board_id: board1.id) unless Card.where(body: 'user1 is very glad #2').exists?
Card.create(kind: 'sad', body: 'user2 is very sad', author_id: user2.id, board_id: board1.id) unless Card.where(body: 'user2 is very sad').exists?
Card.create(kind: 'mad', body: 'user3 is very mad', author_id: user3.id, board_id: board1.id) unless Card.where(body: 'user3 is very mad').exists?
Card.create(kind: 'mad', body: 'user4 is very mad', author_id: user4.id, board_id: board1.id) unless Card.where(body: 'user4 is very mad').exists?
Card.create(kind: 'mad', body: 'user5 is very mad', author_id: user5.id, board_id: board1.id) unless Card.where(body: 'user5 is very mad').exists?

ActionItem.create(body: 'issue should be fixed', board_id: board1.id, author_id: user1.id) unless ActionItem.where(body: 'issue should be fixed', board_id: board1.id, author_id: user1.id).exists?
ActionItem.create(body: 'meetings should be held', board_id: board1.id, author_id: user1.id) unless ActionItem.where(body: 'meetings should be held', board_id: board1.id, author_id: user1.id).exists?
ActionItem.create(body: 'actions should be taken', board_id: board1.id, author_id: user1.id) unless ActionItem.where(body: 'actions should be taken', board_id: board1.id, author_id: user1.id).exists?

Rake::Task['permissions:create_missing_for_boards'].invoke
Rake::Task['permissions:create_missing_for_cards'].invoke
Rake::Task['permissions:create_missing_for_comments'].invoke
