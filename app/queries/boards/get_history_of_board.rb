# frozen_string_literal: true

module Boards
  class GetHistoryOfBoard
    attr_reader :board

    def initialize(board)
      @board = board
    end

    def call
      boards_ids = Board.connection.execute(history_query).values.flatten.drop(1)
      Board.where(id: boards_ids)
    end

    private

    HISTORY_OF_BOARD = <<~SQL
      WITH RECURSIVE previous_boards(id, previous_board_id) AS (
      SELECT id, previous_board_id FROM boards WHERE id = ?
      UNION ALL
      SELECT c.id, c.previous_board_id FROM previous_boards AS p, boards AS c WHERE c.id = p.previous_board_id
      )
      SELECT id FROM previous_boards;
    SQL

    def history_query
      ActiveRecord::Base.send(:sanitize_sql_array, [HISTORY_OF_BOARD, board.id])
    end
  end
end
