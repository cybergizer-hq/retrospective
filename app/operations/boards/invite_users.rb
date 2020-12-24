# frozen_string_literal: true

module Boards
  class InviteUsers
    include Dry::Monads[:result]
    attr_reader :board, :users

    def initialize(board, users)
      @board = board
      @users = users
    end

    def call
      users_data = users.map { |user| { role: 'member', user_id: user.id } }
      memberships = board.memberships.build(users_data)

      @users.find_each do |user|
        BuildPermissions.new(@board, user).call(identifiers_scope: 'member')
      end

      board.save
      Success(memberships)
    end
  end
end
