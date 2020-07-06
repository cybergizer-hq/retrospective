# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::AddCardMutation, type: :request do
  describe '.resolve' do
    let(:author) { create(:user) }
    let(:board) { create(:board) }
    # rubocop:disable Metrics/LineLength
    let(:request) { post '/graphql', params: { query: query(author_id: author.id, board_id: board.id) } }
    # rubocop:enable Metrics/LineLength

    it 'creates a card' do
      expect { request }.to change { Card.count }.by(1)
    end

    it 'returns a card' do
      request
      json = JSON.parse(response.body)
      data = json.dig('data', 'addCard', 'card')

      expect(data).to include(
        'id' => be_present,
        'kind' => 'mad',
        'body' => 'Some text',
        'author' => { 'id' => author.id.to_s },
        'boardId' => board.id.to_s
      )
    end
  end

  def query(author_id:, board_id:)
    <<~GQL
      mutation {
        addCard(
          input: {
            attributes: {
              authorId: #{author_id}
              boardId: #{board_id}
              kind: "mad"
              body: "Some text"
            }
          }
        ) {
          card {
            id
            kind
            body
            author {
              id
            }
            boardId
          }
        }
      }
    GQL
  end
end
