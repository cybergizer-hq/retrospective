# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::AddActionItemMutation, type: :request do
  describe '.resolve' do
    let_it_be(:author) { create(:user) }
    let_it_be(:board) { create(:board) }
    let(:request) { post '/graphql', params: { query: query(board_slug: board.slug) } }

    let_it_be(:creatorship) do
      create(:membership, board: board, user: author, role: 'creator')
    end

    before { sign_in author }

    it 'creates an action item' do
      expect { request }.to change { ActionItem.count }.by(1)
    end

    it 'returns an action item' do
      request
      json = JSON.parse(response.body)
      data = json.dig('data', 'addActionItem', 'actionItem')

      expect(data).to include(
        'id' => be_present,
        'body' => 'Some text'
      )
    end
  end

  def query(board_slug:)
    <<~GQL
      mutation {
        addActionItem(
          input: {
            attributes: {
              boardSlug: "#{board_slug}"
              body: "Some text"
            }
          }
        ) {
          actionItem {
            id
            body
            times_moved
          }
        }
      }
    GQL
  end
end
