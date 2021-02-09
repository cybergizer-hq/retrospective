# frozen_string_literal: true

require 'rails_helper'

describe 'Board API', type: :request do
  let_it_be(:author) { create(:user) }
  let_it_be(:board1) { create(:board) }

  before { login_as author }

  describe 'GET /api/v1/boards' do
    let_it_be(:board2) { create(:board) }

    before { get '/api/v1/boards' }

    it 'return 200' do
      expect(response.status).to eq(200)
    end

    it 'return boards' do
      handler = serialize_resource([board1, board2])

      expect(json_body).to eq(JSON.parse(handler))
    end
  end

  describe 'GET /api/v1/boards/:id' do
    before { get "/api/v1/boards/#{board1.id}" }

    it 'return 200' do
      expect(response.status).to eq(200)
    end

    it 'return board' do
      handler = serialize_resource(board1)

      expect(json_body).to eq(JSON.parse(handler))
    end
  end
end
