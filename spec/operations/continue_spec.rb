# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::Continue do
  include Dry::Monads[:result]

  let!(:prev_creator) { create(:user) }
  let!(:prev_admin) { create(:user) }
  let!(:prev_host) { create(:user) }
  let!(:current_user) { create(:user) }
  let!(:prev_board) { create(:board) }
  let!(:creatorship) do
    create(:membership, board: prev_board, user: prev_creator, role: 'creator', ready: true)
  end
  let!(:adminship) do
    create(:membership, board: prev_board, user: prev_admin, role: 'admin', ready: true)
  end
  let!(:hostship) do
    create(:membership, board: prev_board, user: prev_host, role: 'host', ready: true)
  end
  let!(:membership) do
    create(:membership, board: prev_board, user: current_user, role: 'member')
  end

  subject { described_class.new(prev_board, current_user).call }

  context 'when prev_board was previously continued' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:prev_board_continued?)
        .and_return(true)
    end

    it { is_expected.to be_a(Dry::Monads::Result::Failure) }
    it 'fails with standard error' do
      expect(subject.failure).to be_a(StandardError)
      expect(subject.failure.message)
        .to eq 'This board was already continued! Only one continuation per board is allowed!'
    end
  end

  context 'when prev_board was not previously continued' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:prev_board_continued?)
        .and_return(false)
    end

    it { is_expected.to be_a(Dry::Monads::Result::Success) }
    it 'returns board in the result value' do
      expect(subject.value!).to be_instance_of(Board)
    end
    it 'duplicates memberships from the previous board' do
      expect { subject }.to change(Membership, :count).by(prev_board.memberships.count)
    end
    it 'assigns duplicated memberships to the new board' do
      expect(subject.value!.users).to contain_exactly(*prev_board.users)
    end
    it 'sets dupicated memberships ready statuses to false' do
      expect(subject.value!.memberships).not_to include(be_ready)
    end
    it 'sets prev_creator as the creator of the new board' do
      expect(subject.value!.memberships.find_by(role: 'creator').user_id).to eq prev_creator.id
    end
    it 'sets prev_admin as the admin of the new board' do
      expect(subject.value!.memberships.find_by(role: 'admin').user_id).to eq prev_admin.id
    end
    it 'sets prev_host as the host of the new board' do
      expect(subject.value!.memberships.find_by(role: 'host').user_id).to eq prev_host.id
    end
    it 'sets previous privacy settings to new board' do
      expect(subject.value!.private).to eq prev_board.private
    end
  end
end
