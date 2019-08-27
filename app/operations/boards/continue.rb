# frozen_string_literal: true

module Boards
  class Continue
    include Resultable
    attr_reader :prev_board

    def initialize(prev_board)
      @prev_board = prev_board
    end

    def call
      new_board = Board.new(
        title: default_board_name,
        previous_board_id: prev_board.id
      )
      new_board.memberships = prev_board.memberships.map(&:dup)
      new_board.save!

      Success(new_board)
    rescue StandardError => e
      Failure(e)
    end

    def default_board_name
      Date.today.strftime('%d-%m-%Y')
    end
  end
end