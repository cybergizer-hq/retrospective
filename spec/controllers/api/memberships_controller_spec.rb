# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::MembershipsController do
  let(:creator) { build_stubbed(:user) }
  let(:member) { build_stubbed(:user) }
  let(:not_member) { build_stubbed(:user) }
  let(:board) { build_stubbed(:board) }

  let(:creatorship) do
    build_stubbed(:membership, board: board, user: creator, role: 'creator')
  end

  let(:membership) do
    build_stubbed(:membership, board: board, user: member, role: 'member')
  end

  describe 'GET #index' do
    subject(:response) { get :index, params: params }

    let(:params) { { board_slug: board.slug } }

    context 'authentication' do
      it_behaves_like :controllers_api_unauthenticated_action
    end

    context 'happy path' do
      before do
        login_as(member)
        authorize

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
        allow(board).to receive(:memberships).and_return([membership])

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: member.id)
          .and_return(membership)
      end

      it_behaves_like :controllers_api_successful_action

      it { is_expected.to match_json_schema('api/memberships/index') }
    end
  end

  describe 'DELETE #destroy' do
    subject(:response) { delete :destroy, params: params }

    let(:params) { { board_slug: board.slug, id: membership.id } }

    context 'authentication' do
      it_behaves_like :controllers_api_unauthenticated_action
    end

    context 'authorization' do
      before do
        login_as(member)

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
        allow(Membership).to receive(:find).with(params[:id].to_s).and_return(membership)

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: member.id)
          .and_return(membership)
      end

      it_behaves_like :controllers_api_unauthorized_action
    end

    context 'happy path' do
      before do
        login_as(creator)
        authorize

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
        allow(Membership).to receive(:find).with(params[:id].to_s).and_return(membership)
        allow(membership).to receive(:destroy).and_return(true)

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: creator.id)
          .and_return(membership)
      end

      it 'broadcasts created item' do
        expect { delete :destroy, params: params }.to have_broadcasted_to("board_#{board.slug}")
      end

      it_behaves_like :controllers_api_successful_action, :no_content
    end
  end

  describe 'GET #ready_status' do
    subject(:response) { post :ready_status, params: params }

    let(:params) { { board_slug: board.slug, id: membership.id } }

    context 'authentication' do
      it_behaves_like :controllers_api_unauthenticated_action
    end

    context 'authorization' do
      before do
        login_as(not_member)

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: not_member.id)
          .and_return(nil)
      end

      it_behaves_like :controllers_api_unauthorized_action
    end

    context 'happy path' do
      before do
        login_as(member)
        authorize

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: member.id)
          .and_return(membership)
      end

      it_behaves_like :controllers_api_successful_action
    end
  end

  describe 'PUT #ready_toggle' do
    subject(:response) { post :ready_toggle, params: params }

    let(:params) { { board_slug: board.slug, id: membership.id } }

    context 'authentication' do
      it_behaves_like :controllers_api_unauthenticated_action
    end

    context 'authorization' do
      before do
        login_as(not_member)

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: not_member.id)
          .and_return(nil)
      end

      it_behaves_like :controllers_api_unauthorized_action
    end

    context 'happy path' do
      before do
        login_as(member)
        authorize

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
        allow(membership).to receive(:update).with(ready: !membership.ready).and_return(membership)

        allow(Membership)
          .to receive(:find_by)
          .with(board_id: board.id, user_id: member.id)
          .and_return(membership)
      end

      it_behaves_like :controllers_api_successful_action
    end
  end
end
