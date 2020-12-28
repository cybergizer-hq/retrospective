# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ToggleReadyStatusMutation, type: :request do
  describe '.resolve' do
    let_it_be(:author) { create(:user) }
    let_it_be(:board) { create(:board) }
    let_it_be(:creatorship) do
      create(:membership, board: board, user: author, role: 'creator')
    end
    let(:request) { post '/graphql', params: { query: query(id: creatorship.id) } }

    before { sign_in author }

    it 'toggles membership status' do
      request

      expect(creatorship.reload).to have_attributes(
        'ready' => true
      )
    end

    it 'returns a membership' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'toggleReadyStatus', 'membership')

      expect(data).to include(
        'id' => creatorship.id,
        'ready' => true,
        'user' => { 'id' => creatorship.user_id.to_s },
        'boardId' => creatorship.board_id
      )
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        toggleReadyStatus(
          input: {
            id: #{id}
          }
        ) {
          membership {
            id
            ready
            user {
              id
            }
            boardId
          }
        }
      }
    GQL
  end
end
