# frozen_string_literal: true

require 'rails_helper'

describe 'Action Item API', type: :request do
  let_it_be(:author) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:creatorship) do
    create(:membership, board: board, user: author, role: 'creator')
  end

  before { login_as author }

  describe 'POST /api/v1/action_items' do
    let(:request) do
      post '/api/v1/action_items', params: { body: 'test item', board_slug: board.slug,
                                             assignee_id: author.id }
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'return created action item' do
      request

      expect(json_body['data']['actionItem']).to include('body' => 'test item')
    end

    it 'create action item in db' do
      expect { request }.to change { ActionItem.count }.by(1)
    end

    it 'broadcast created item' do
      expect { request }.to have_broadcasted_to(board).from_channel(ActionItemsChannel)
                                                      .with(start_with('{"data":{"actionItem":'))
    end
  end

  describe 'PUT /api/v1/action_items/:id' do
    let_it_be(:new_assignee) { create(:user) }
    let_it_be(:action_item) { create(:action_item, board: board) }

    let(:request) do
      put "/api/v1/action_items/#{action_item.id}", params: { body: 'new text',
                                                              assignee_id: new_assignee.id }
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'return updated action item' do
      request
      handler = serialize_resource(action_item.reload)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast updated item' do
      handler = serialize_resource(action_item)

      expect { request }.to have_broadcasted_to(board).from_channel(ActionItemsChannel)
                                                      .with(handler)
    end
  end

  describe 'DELETE /api/v1/action_items/:id' do
    let_it_be(:action_item) { create(:action_item, board: board) }

    let(:request) { delete "/api/v1/action_items/#{action_item.id}" }

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'return deleted action item' do
      request
      handler = serialize_resource(action_item)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'delete action item in db' do
      expect { request }.to change { ActionItem.count }.by(-1)
    end

    it 'broadcast deleted item' do
      handler = serialize_resource(action_item)

      expect { request }.to have_broadcasted_to(board).from_channel(ActionItemsChannel)
                                                      .with(handler)
    end
  end

  describe 'PUT /api/v1/action_items/:id/close' do
    let_it_be(:action_item) { create(:action_item, board: board) }

    let(:request) do
      put "/api/v1/action_items/#{action_item.id}/close", params: { board_slug: board.slug }
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'action item became closed' do
      request

      expect(action_item.reload).to have_attributes(
        'status' => 'closed'
      )
    end

    it 'return closed action item' do
      request
      handler = serialize_resource(action_item.reload)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast closed item' do
      handler = serialize_resource(action_item)

      expect { request }.to have_broadcasted_to(board).from_channel(ActionItemsChannel)
                                                      .with(handler)
    end
  end

  describe 'PUT /api/v1/action_items/:id/compete' do
    let_it_be(:action_item) { create(:action_item, board: board) }

    let(:request) do
      put "/api/v1/action_items/#{action_item.id}/complete", params: { board_slug: board.slug }
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'action item became competed' do
      request

      expect(action_item.reload).to have_attributes(
        'status' => 'done'
      )
    end

    it 'return completed action item' do
      request
      handler = serialize_resource(action_item.reload)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast completed item' do
      handler = serialize_resource(action_item)

      expect { request }.to have_broadcasted_to(board).from_channel(ActionItemsChannel)
                                                      .with(handler)
    end
  end

  describe 'PUT /api/v1/action_items/:id/reopen' do
    let_it_be(:action_item) { create(:action_item, board: board, status: 'done') }

    let(:request) do
      put "/api/v1/action_items/#{action_item.id}/reopen", params: { board_slug: board.slug }
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'action item became reopen' do
      request

      expect(action_item.reload).to have_attributes(
        'status' => 'pending'
      )
    end

    it 'return reopened action item' do
      request
      handler = serialize_resource(action_item.reload)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast reopened item' do
      handler = serialize_resource(action_item)

      expect { request }.to have_broadcasted_to(board).from_channel(ActionItemsChannel)
                                                      .with(handler)
    end
  end

  describe 'PUT /api/v1/action_items/:id/move' do
    let_it_be(:new_board) { create(:board) }
    let_it_be(:creatorship2) do
      create(:membership, board: new_board, user: author, role: 'creator')
    end
    let_it_be(:action_item) { create(:action_item, board: board) }

    let(:request) do
      put "/api/v1/action_items/#{action_item.id}/move", params: { board_slug: new_board.slug }
    end

    # before do
    #   put "/api/v1/action_items/#{action_item.id}/move", params: { board_slug: new_board.slug }
    # end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'action item became move' do
      request

      expect(action_item.reload).to have_attributes(
        'board_id' => new_board.id,
        'times_moved' => 1
      )
    end

    it 'return moved action item' do
      request
      handler = serialize_resource(action_item.reload)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast moved item' do
      handler = serialize_resource(action_item)

      expect { request }.to have_broadcasted_to(new_board).from_channel(ActionItemsChannel)
                                                          .with(handler)
    end
  end
end
