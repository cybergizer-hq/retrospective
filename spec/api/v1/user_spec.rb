# frozen_string_literal: true

require 'rails_helper'

describe 'User API', type: :request do
  describe '/api/v1/suggestions' do
    let_it_be(:user) { create(:user) }

    before { login_as user }

    it 'return 200' do
      post '/api/v1/suggestions', params: { autocomplete: user.email[0] }

      expect(response.status).to eq(200)
    end

    context 'users' do
      it 'contains users suggestions' do
        post '/api/v1/suggestions', params: { autocomplete: user.email[0] }

        expect(json_body['data']['suggestions']['users'][0]).to eq(user.email)
      end
    end

    context 'teams' do
      let_it_be(:team) { create(:team) }

      it 'contains teams suggestions' do
        post '/api/v1/suggestions', params: { autocomplete: team.name[0] }

        expect(json_body['data']['suggestions']['teams'][0]).to eq(team.name)
      end
    end
  end
end
