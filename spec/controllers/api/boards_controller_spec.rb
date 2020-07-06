# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::BoardsController do
  let(:member) { build_stubbed(:user) }
  let(:not_member) { build_stubbed(:user) }
  let(:board) { build_stubbed(:board) }

  describe 'POST #invite' do
    subject(:response) { post :invite, params: params }
    let(:params) { { slug: board.slug } }

    context 'authentication' do
      it_behaves_like :controllers_api_unauthenticated_action
    end

    context 'authorization' do
      before do
        login_as(not_member)

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
      end

      it_behaves_like :controllers_api_unauthorized_action
    end

    context 'happy path' do
      let(:invitee_1) { build_stubbed(:user) }
      let(:invitee_2) { build_stubbed(:user) }

      let(:membership_1) { build_stubbed(:membership, board: board, user: invitee_1) }
      let(:membership_2) { build_stubbed(:membership, board: board, user: invitee_2) }

      let(:params) do
        super().merge(board: { email: "#{invitee_1.email},#{invitee_2.email}" })
      end

      before do
        login_as(member)
        authorize

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)

        allow_any_instance_of(Boards::FindUsersToInvite)
          .to receive(:call)
          .and_return([invitee_1, invitee_2])
        allow_any_instance_of(Boards::InviteUsers)
          .to receive(:call)
          .and_return(Dry::Monads.Success([membership_1, membership_2]))
      end

      it_behaves_like :controllers_api_successful_action

      it { is_expected.to match_json_schema('api/boards/invite') }
    end
  end

  describe 'POST #suggestions' do
    subject(:response) { post :suggestions, params: params }
    let(:params) { { slug: board.slug } }

    context 'authentication' do
      it_behaves_like :controllers_api_unauthenticated_action
    end

    context 'authorization' do
      before do
        login_as(not_member)

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
      end

      it_behaves_like :controllers_api_unauthorized_action
    end

    context 'happy path' do
      let(:params) { super().merge(autocomplete: 'suggestion') }

      let(:result) do
        {
          users: [
            'suggestion_user_1@example.com',
            'SUGGESTION_USER_2@example.com'
          ],
          teams: [
            'suggestion_team'
          ]
        }
      end

      before do
        login_as(member)
        authorize

        allow(Board).to receive(:find_by!).with(slug: board.slug).and_return(board)
        allow_any_instance_of(Boards::Suggestions).to receive(:call).and_return(result)
      end

      it_behaves_like :controllers_api_successful_action

      it { is_expected.to match_json_schema('api/boards/suggestions') }
    end
  end
end
