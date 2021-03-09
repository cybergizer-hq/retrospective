# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ReopenActionItemMutation, type: :request do
  describe '.resolve' do
    let_it_be(:user) { create(:user) }
    let_it_be(:old_board) { create(:board) }
    let_it_be(:board) { create(:board) }
    let_it_be(:action_item) { create(:action_item, board: old_board, status: 'closed') }
    let(:reopen_permission) { create(:permission, identifier: 'reopen_action_items') }
    let(:request) do
      post '/graphql', params: { query: query(id: action_item.id,
                                              board_slug: board.slug) }
    end

    before { sign_in user }

    context 'with permission' do
      before do
        create(:board_permissions_user, permission: reopen_permission, user: user, board: board)
      end

      it 'updates an action_item' do
        expect { request }.to change { action_item.reload.status }.to 'pending'
      end

      it 'returns an action item' do
        request
        json = JSON.parse(response.body)
        data = json.dig('data', 'reopenActionItem', 'actionItem')

        expect(data).to include(
          'id' => action_item.id
        )
      end
    end

    context 'without permission' do
      it 'updates an action item' do
        expect { request }.to_not change { action_item.reload.status }
      end
    end
  end

  def query(id:, board_slug:)
    <<~GQL
      mutation {
        reopenActionItem(
          input: {
            id: #{id}
            boardSlug: "#{board_slug}"
          }
        ) {
          actionItem {
            id
          }
        }
      }
    GQL
  end
end
