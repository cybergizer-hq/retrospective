# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateActionItemMutation, type: :request do
  describe '.resolve' do
    let(:author) { create(:user) }
    let!(:board) { create(:board) }
    let!(:new_assignee) { create(:user) }
    let!(:action_item) { create(:action_item, board: board, assignee: author) }
    let(:request) do
      post '/graphql', params: { query: query(id: action_item.id,
                                              body: 'New body',
                                              assignee_id: new_assignee.id) }
    end
    let!(:creatorship) do
      create(:membership, board: board, user: author, role: 'creator')
    end
    before { sign_in author }

    it 'updates an action item' do
      request

      expect(action_item.reload).to have_attributes(
        body: 'New body',
        assignee_id: new_assignee.id
      )
    end

    it 'can nullify assignee' do
      post '/graphql', params: { query: query(id: action_item.id,
                                              body: 'New body',
                                              assignee_id: nil) }

      expect(action_item.reload).to have_attributes(
        body: 'New body',
        assignee_id: nil
      )
    end

    it 'returns a card' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'updateActionItem', 'actionItem')
      expect(data).to include(
        'id' => action_item.id,
        'body' => 'New body'
      )
    end
  end

  def query(id:, body:, assignee_id:)
    <<~GQL
      mutation {
        updateActionItem(
          input: {
            id: #{id}
            attributes: {
              body: "#{body}"
              assigneeId: "#{assignee_id}"
            }
          }
        ) {
          actionItem {
            id
            body
          }
        }
      }
    GQL
  end
end
