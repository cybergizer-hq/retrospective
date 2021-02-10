# frozen_string_literal: true

require 'rails_helper'

describe 'Membership API', type: :request do
  let_it_be(:author) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:creatorship) { create(:membership, user: author, board: board, role: 'creator') }

  before { login_as author }

  describe 'index, current, destroy' do
    let_it_be(:non_author) { create(:user) }
    let_it_be(:membership) { create(:membership, user: non_author, board: board) }

    describe 'GET /api/v1/memberships' do
      before do
        get '/api/v1/memberships', params: { board_slug: board.slug }
      end

      it 'return 200' do
        expect(response.status).to eq(200)
      end

      it 'return memberships' do
        handler = serialize_resource([creatorship, membership])

        expect(json_body).to eq(JSON.parse(handler))
      end
    end

    describe 'GET /api/v1/memberships/current' do
      before do
        get '/api/v1/memberships/current', params: { board_slug: board.slug }
      end

      it 'return 200' do
        expect(response.status).to eq(200)
      end

      it 'return current membership' do
        handler = serialize_resource(creatorship)

        expect(json_body).to eq(JSON.parse(handler))
      end
    end

    describe 'DELETE /api/v1/memberships/:id' do
      let_it_be(:member_permission) { create(:permission, identifier: 'some_identifier') }
      let_it_be(:destroy_permission) { create(:permission, identifier: 'destroy_membership') }

      let(:request) { delete "/api/v1/memberships/#{membership.id}" }

      before do
        create(:permissions_user, permission: member_permission, user: non_author, board: board)
        create(:permissions_user, permission: destroy_permission, user: author, board: board)
      end

      it 'return 200' do
        request

        expect(response.status).to eq(200)
      end

      it 'return deleted membership' do
        request
        handler = serialize_resource(membership)

        expect(json_body).to eq(JSON.parse(handler))
      end

      it 'delete membership in db' do
        expect { request }.to change { Membership.count }.by(-1)
      end

      it 'delete permissions in db' do
        expect { request }.to change { non_author.permissions.count }.by(-1)
      end

      it 'broadcast deleted membership' do
        handler = serialize_resource(membership)

        expect { request }.to have_broadcasted_to(board).from_channel(MembershipsChannel)
                                                        .with(handler)
      end
    end
  end

  describe 'POST /api/v1/memberships' do
    let_it_be(:invite_permission) { create(:permission, identifier: 'invite_members') }
    let_it_be(:permissions_user) do
      create(:permissions_user, permission: invite_permission, user: author, board: board)
    end

    let(:invitee1) { build_stubbed(:user) }
    let(:invitee2) { build_stubbed(:user) }
    let(:membership1) { build_stubbed(:membership, board: board, user: invitee1) }
    let(:membership2) { build_stubbed(:membership, board: board, user: invitee2) }

    let(:request) do
      post '/api/v1/memberships/', params: { board_slug: board.slug,
                                             email: "#{invitee1.email},#{invitee2.email}" }
    end

    before do
      allow_any_instance_of(Boards::FindUsersToInvite)
        .to receive(:call)
        .and_return([invitee1, invitee2])
      allow_any_instance_of(Boards::InviteUsers)
        .to receive(:call)
        .and_return(Dry::Monads.Success([membership1, membership2]))
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'return created membership' do
      request

      handler = serialize_resource([membership1, membership2])

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast created membership' do
      expect { request }.to have_broadcasted_to(board).from_channel(MembershipsChannel)
                                                      .with(
                                                        start_with('{"data":{"memberships":')
                                                      )
    end
  end

  describe 'PUT /api/v1/memberships/:id/toggle_ready_status' do
    let_it_be(:permission) { create(:permission, identifier: 'toggle_ready_status') }

    let(:request) { put "/api/v1/memberships/#{creatorship.id}/toggle_ready_status" }

    before do
      create(:permissions_user, permission: permission, board: board, user: author)
    end

    it 'return 200' do
      request

      expect(response.status).to eq(200)
    end

    it 'toggled membership status' do
      request

      expect(creatorship.reload).to have_attributes(
        'ready' => true
      )
    end

    it 'return toggled membership' do
      request

      handler = serialize_resource(creatorship.reload)

      expect(json_body).to eq(JSON.parse(handler))
    end

    it 'broadcast toggled membership' do
      handler = serialize_resource(creatorship)

      expect { request }.to have_broadcasted_to(board).from_channel(MembershipsChannel)
                                                      .with(handler)
    end
  end
end
