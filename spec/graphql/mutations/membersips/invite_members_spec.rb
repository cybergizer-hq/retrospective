# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::InviteMembersMutation, type: :request do
  describe '.resolve' do
    let!(:author) { create(:user) }
    let!(:board) { create(:board) }
    let!(:creatorship) do
      create(:membership, board: board, user: author, role: 'creator')
    end

    let(:invitee1) { build_stubbed(:user) }
    let(:invitee2) { build_stubbed(:user) }

    let(:membership1) { build_stubbed(:membership, board: board, user: invitee1) }
    let(:membership2) { build_stubbed(:membership, board: board, user: invitee2) }

    let(:request) do
      post '/graphql', params: { query: query(board_slug: board.slug,
                                              email: "#{invitee1.email},#{invitee2.email}") }
    end

    before do
      sign_in author
      allow_any_instance_of(Boards::FindUsersToInvite)
        .to receive(:call)
        .and_return([invitee1, invitee2])
      allow_any_instance_of(Boards::InviteUsers)
        .to receive(:call)
        .and_return(Dry::Monads.Success([membership1, membership2]))
    end

    it 'returns a list of memberships' do
      request
      json = JSON.parse(response.body)
      data = json.dig('data', 'inviteMembers', 'memberships')

      expect(data).to match_array(
        [
          {
            'id' => membership1.id,
            'ready' => membership1.ready,
            'boardId' => membership1.board_id,
            'user' => {
              'id' => membership1.user_id.to_s
            }
          },
          {
            'id' => membership2.id,
            'ready' => membership2.ready,
            'boardId' => membership2.board_id,
            'user' => {
              'id' => membership2.user_id.to_s
            }
          }
        ]
      )
    end
  end

  def query(board_slug:, email:)
    <<~GQL
      mutation {
        inviteMembers(
          input: {
            boardSlug: "#{board_slug}"
            email: "#{email}"
          }
        ) {
          memberships {
            id
            ready
            boardId
            user {
              id
            }
          }
          errors {
            fullMessages
          }
        }
      }
    GQL
  end
end
