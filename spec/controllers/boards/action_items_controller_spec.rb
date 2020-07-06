# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::ActionItemsController do
  let_it_be(:board) { create(:board) }
  let_it_be(:action_item) { create(:action_item, board: board) }
  let_it_be(:closed_action_item) { create(:action_item, status: 'closed', board: board) }
  let_it_be(:creator) { create(:user) }
  let_it_be(:member) { create(:user) }
  let_it_be(:not_member) { create(:user) }
  let_it_be(:creatorship) do
    create(:membership, board: board, user: creator, role: 'creator')
  end
  let_it_be(:membership) do
    create(:membership, board: board, user: member, role: 'member')
  end

  before { bypass_rescue }

  describe 'POST #create' do
    subject(:response) { post :create, params: params }
    let_it_be(:params) do
      { board_slug: board.slug,
        action_item: FactoryBot.attributes_for(:action_item) }
    end

    context 'when user is not logged in' do
      it { is_expected.to have_http_status(:redirect) }
    end

    context 'when user is logged_in' do
      context 'user is not a board member' do
        before { login_as not_member }
        it 'raises error ActionPolicy::Unauthorized' do
          expect { post :create, params: params }.to raise_error(ActionPolicy::Unauthorized)
        end
      end

      context 'user is a board member' do
        before { login_as member }
        it 'raises error ActionPolicy::Unauthorized' do
          expect { post :create, params: params }.to raise_error(ActionPolicy::Unauthorized)
        end
      end

      context 'user is the board creator' do
        before { login_as creator }
        context 'with valid params' do
          it { is_expected.to have_http_status(:redirect) }
          it 'broadcasts new item' do
            expect { post :create, params: params }.to have_broadcasted_to("board_#{board.slug}")
          end
        end

        # rubocop:disable Metrics/LineLength
        context 'is valid without assignee' do
          let_it_be(:params) { params.merge action_item: { assignee: nil, body: params[:action_item][:body] } }
          it { is_expected.to have_http_status(:redirect) }
          it 'broadcasts new item' do
            expect { post :create, params: params }.to have_broadcasted_to("board_#{board.slug}")
          end
        end

        context 'is valid with assignee' do
          let_it_be(:params) { params.merge action_item: { assignee_id: creator.id, body: params[:action_item][:body] } }
          it { is_expected.to have_http_status(:redirect) }
          it 'broadcasts new item' do
            expect { post :create, params: params }.to have_broadcasted_to("board_#{board.slug}")
          end
        end

        # rubocop:enable Metrics/LineLength
        context 'with invalid params' do
          let_it_be(:params) { params.merge action_item: { body: nil } }
          it { is_expected.to have_http_status(:redirect) }
        end
      end
    end
  end
end
