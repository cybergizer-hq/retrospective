# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateCardMutation, type: :request do
  describe '.resolve' do
    let(:card) { create(:card) }
    let(:author) { create(:user) }
    let(:request) { post '/graphql', params: { query: query(id: card.id, author_id: author.id) } }

    it 'updates a card' do
      request

      expect(card.reload).to have_attributes(
        'author_id' => author.id,
        'body' => card.body
      )
    end

    it 'returns a card' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'updateCard', 'card')

      expect(data).to include(
        'id' => card.id.to_s,
        'body' => card.body,
        'author' => { 'id' => author.id.to_s }
      )
    end
  end

  def query(id:, author_id:)
    <<~GQL
      mutation {
        updateCard(
          input: {
            id: #{id}
            attributes: {
              authorId: #{author_id}
            }
          }
        ) {
          card {
            id
            body
            author {
              id
            }
          }
        }
      }
    GQL
  end
end
