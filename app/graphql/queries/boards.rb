# frozen_string_literal: true

module Queries
  class Boards < Queries::BaseQuery
    description 'Returns a list of boards'

    type [Types::BoardType], null: false

    def resolve
      ::Board.limit(10)
    end
  end
end
