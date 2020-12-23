# frozen_string_literal: true

module Boards
  class Continue
    include Dry::Monads[:result]
    attr_reader :prev_board, :current_user

    def initialize(prev_board, current_user)
      @prev_board = prev_board
      @current_user = current_user
    end

    # rubocop:disable Metrics/MethodLength
    def call
      if prev_board_continued?
        raise StandardError,
              'This board was already continued! Only one continuation per board is allowed!'
      end

      new_board = Board.new(
        title: new_board_title,
        previous_board_id: prev_board.id,
        column_names: prev_board.column_names,
        private: prev_board.private
      )

      new_board.memberships = duplicate_memberships
      new_board.permissions_users = duplicate_permissions_users
      new_board.save!

      Success(new_board)
    rescue StandardError => e
      Failure(e)
    end
    # rubocop:enable Metrics/MethodLength

    private

    def new_board_title
      prev_board.title.split('#')[0] + " ##{board_number}"
    end

    def board_number
      Boards::GetHistoryOfBoard.new(prev_board.id).call.size + 1 if prev_board
    end

    def duplicate_memberships
      prev_board.memberships
                .map(&:dup)
                .each do |member|
                  member.ready = false
                end
    end

    def duplicate_permissions_users
      prev_board.permissions_users.map(&:dup)
    end

    def default_board_name
      Date.today.strftime('%d-%m-%Y')
    end

    def prev_board_continued?
      Board.exists?(previous_board_id: prev_board.id)
    end
  end
end
