# frozen_string_literal: true

module Queries
  class Memberships < Queries::BaseQuery
    description 'Returns memberships by board slug'

    argument :board_slug, String, required: true

    type [Types::MembershipType], null: false

    def resolve(board_slug:)
      ::Board.find_by!(slug: board_slug).memberships.includes([:user])
    end
  end
end
