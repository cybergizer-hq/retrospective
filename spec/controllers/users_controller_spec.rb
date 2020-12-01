# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let_it_be(:user) { create(:user) }

  context 'GET #edit' do
    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      before { login(user) }
      it_behaves_like :controllers_render, :edit
    end
  end

  context 'PATCH #update' do
    context 'when user is not logged in' do
      it_behaves_like :controllers_unauthenticated_action
    end

    context 'when user is logged in' do
      before { login(user) }
    end
  end
end
