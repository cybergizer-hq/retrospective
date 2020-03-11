require 'rails_helper'

RSpec.describe Mutations::DestroyCardMutation, type: :request do
  describe '#resolve' do
    let(:card) { create(:card, author: author) }
    let(:author) { create(:user) }
    let(:request) { post '/graphql', params: { query: query(id: card.id) } }

    it 'removes card' do
      expect { request.to change { Card.count }.by(-1) }
    end

    it 'returns a card' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'destroyCard', 'card')

      expect(data).to include(
                          'id'       => card.id.to_s,
                          'kind'     => card.kind,
                          'body'     => card.body,
                          'boardId' => card.board.id.to_s,
                          'author'   => { 'id' => author.id.to_s }
                      )
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        destroyCard(
          input: {
            id: #{id}
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
