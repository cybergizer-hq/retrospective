# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardsController do
  let_it_be(:creator) { create(:user) }
  let_it_be(:member) { create(:user) }
  let_it_be(:not_member) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:creatorship) { create(:membership, board: board, user: creator, role: 'creator') }
  let_it_be(:membership) { create(:membership, board: board, user: member) }

  before { bypass_rescue }

  describe 'GET #index' do
    subject(:response) { get :index }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when any user is logged in' do
      before { login_as not_member }
      it_behaves_like :controllers_render, :index
    end
  end

  describe 'GET #new' do
    subject(:response) { get :new }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when any user is logged in' do
      before { login_as not_member }
      it_behaves_like :controllers_render, :new
    end
  end

  describe 'GET #show' do
    subject(:response) { get :show, params: { slug: board.slug } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_render, :show
    end

    context 'when any user is logged in' do
      before { login_as not_member }
      it_behaves_like :controllers_render, :show
    end
  end

  describe 'GET #edit' do
    subject(:response) { get :edit, params: { slug: board.slug } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      context 'user is not a board member' do
        before { login_as not_member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board member' do
        before { login_as member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board creator' do
        before { login_as creator }
        it_behaves_like :controllers_render, :edit
      end
    end
  end

  describe 'GET #create' do
    subject(:response) { post :create, params: params }
    let_it_be(:params) { { board: FactoryBot.attributes_for(:board) } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when any user is logged in' do
      before { login_as not_member }
      context 'when params are invalid' do
        let_it_be(:params) { params.merge board: { title: nil } }

        it_behaves_like :controllers_render, :new
      end

      context 'when params are valid' do
        let_it_be(:params) { params.merge board: { title: Date.today.strftime('%d-%m-%Y') } }

        # no idea how to check redirection to the show view
        # for the object created by the subject call
        it { is_expected.to have_http_status(:redirect) }
      end
    end
  end

  describe 'PATCH #update' do
    subject(:response) { patch :update, params: params }
    let_it_be(:params) { { slug: board.slug } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      context 'user is not a board member' do
        before { login_as not_member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board member' do
        before { login_as member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board creator' do
        before { login_as creator }

        context 'when params are valid' do
          let_it_be(:params) { params.merge board: { title: Faker::Books::Dune.planet } }

          it { is_expected.to have_http_status(:redirect) }
          it { is_expected.to redirect_to edit_board_path(board.slug) }
        end

        context 'when params are invalid' do
          let_it_be(:params) { params.merge board: { title: nil } }

          it_behaves_like :controllers_render, :edit
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:response) { delete :destroy, params: { slug: board.slug } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      context 'user is not a board member' do
        before { login_as not_member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board member' do
        before { login_as member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board creator' do
        before { login_as creator }
        it_behaves_like :controllers_redirect, :boards_path
      end
    end
  end

  describe 'POST #continue' do
    subject(:response) { post :continue, params: params }
    let_it_be(:params) { { slug: board.slug } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when any user is logged in' do
      context 'user is not a board member' do
        before { login_as not_member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board member' do
        before { login_as member }
        it_behaves_like :controllers_unauthorized_action
      end

      context 'user is a board creator' do
        before { login_as creator }
        it { is_expected.to have_http_status(:redirect) }
      end
    end
  end
end
