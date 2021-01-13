# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::InviteUsers do
  subject { described_class.new(board, User.where(id: user.id)).call }
  let!(:user) { create(:user) }
  let!(:board) { create(:board) }
  let_it_be(:permission) { create(:permission, identifier: 'create_cards') }

  it 'creates membership' do
    expect { subject }.to change(Membership, :count).by(1)
  end

  it 'creates permissions' do
    expect { subject }.to change(user.permissions, :count).by(1)
  end

  it 'returns memberships' do
    expect(subject.value!).to eq [Membership.find_by(user_id: user.id, board_id: board.id)]
  end
end
