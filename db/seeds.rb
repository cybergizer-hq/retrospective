# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
              { email: 'tu1@mail.com', password: '123456', nickname: 'tu1' },
              { email: 'tu2@mail.com', password: '123456', nickname: 'tu2' },
              { email: 'tu3@mail.com', password: '123456', nickname: 'tu3' },
              { email: 'tu4@mail.com', password: '123456', nickname: 'tu4' },
              { email: 'tu5@mail.com', password: '123456', nickname: 'tu5' }
            ])

Team.create([
              { name: 'Wolves', user_ids: [1, 2, 3, 4, 5] },
              { name: 'Tigers', user_ids: [1, 5] },
              { name: 'Eagles', user_ids: [2, 3, 4] }
            ])

Board.create([
               { title: 'TestUser1_RetroBoard' },
               { title: 'TestUser2_RetroBoard' },
               { title: 'TestUser3_RetroBoard' },
               { title: 'TestUser4_RetroBoard' },
               { title: 'TestUser5_RetroBoard' }
             ])

Membership.create([
                    { user_id: 1, board_id: 1, role: 'creator', ready: false },
                    { user_id: 2, board_id: 1, role: 'member', ready: false },
                    { user_id: 2, board_id: 2, role: 'creator', ready: false }
                  ])

Card.create([
              { kind: 'mad', body: 'user1 is very mad', author_id: 1, board_id: 1 },
              { kind: 'sad', body: 'user1 is very sad', author_id: 1, board_id: 1 },
              { kind: 'glad', body: 'user1 is very glad #1', author_id: 1, board_id: 1 },
              { kind: 'glad', body: 'user1 is very glad #2', author_id: 1, board_id: 1 },
              { kind: 'sad', body: 'user2 is very sad', author_id: 2, board_id: 1 },
              { kind: 'mad', body: 'user3 is very mad', author_id: 3, board_id: 1 },
              { kind: 'mad', body: 'user4 is very mad', author_id: 4, board_id: 1 },
              { kind: 'mad', body: 'user5 is very mad', author_id: 5, board_id: 1 }
            ])

ActionItem.create([
                    { body: 'issue should be fixed', board_id: 1 },
                    { body: 'meetings should be held', board_id: 1 },
                    { body: 'actions should be taken', board_id: 1 }
                  ])
