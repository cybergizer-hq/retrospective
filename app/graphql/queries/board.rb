# frozen_string_literal: true

module Queries
  class Board < Queries::BaseQuery
    description 'Returns board by id'

    argument :id, ID, required: true

    type Types::BoardType, null: false

    def resolve(id:)
      ::Board.find(id)
    end
  end
end
