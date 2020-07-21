# frozen_string_literal: true

module Boards
  class RenameColumns
    include Dry::Monads[:result]
    attr_reader :board

    def initialize(board)
      @board = board
    end

    def call(prev_names, new_names)
      prev_names.zip(new_names).map do |old_type, new_type|
        unless old_type == new_type
          board.cards.where(kind: old_type)
               .update(kind: new_type)
        end
      end
      Success(board)
    end
  end
end
