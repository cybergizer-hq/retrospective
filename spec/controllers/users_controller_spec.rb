# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let_it_be(:user) { create(:user) }

  context 'GET #edit' do
    subject(:response) { get :edit, params: { id: user.id } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      before { login_as(user) }
      it { is_expected.to have_http_status(:success) }
    end
  end

  context 'PATCH #update' do
    subject(:response) { patch :update, params: params }
    let_it_be(:params) { { id: user.id } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      before { login_as(user) }

      context 'when params are valid' do
        let_it_be(:params) { params.merge user: { nickname: 'nick' } }
        it { is_expected.to have_http_status(:success) }
      end

      context 'when params are invalid' do
        let_it_be(:params) { params.merge user: { nickname: nil } }
        it_behaves_like :controllers_render, :edit
      end
    end
  end

  context 'DELETE #avatar_destroy' do
    subject(:response) { delete :avatar_destroy, params: { id: user.id } }

    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      before { login_as(user) }

      it { is_expected.to have_http_status(:success) }
      it_behaves_like :controllers_render, :edit
    end
  end
end
