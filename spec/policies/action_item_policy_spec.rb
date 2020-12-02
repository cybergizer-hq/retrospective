# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionItemPolicy do
  let_it_be(:creator) { create(:user) }
  let_it_be(:admin) { create(:user) }
  let_it_be(:host) { create(:user) }
  let_it_be(:member) { create(:user) }
  let_it_be(:not_member) { build_stubbed(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:membership) do
    create(:membership, user_id: member.id, board_id: board.id, role: 'member')
  end
  let_it_be(:creatorship) do
    create(:membership, user_id: creator.id, board_id: board.id, role: 'creator')
  end
  let_it_be(:adminship) do
    create(:membership, user_id: admin.id, board_id: board.id, role: 'admin')
  end
  let_it_be(:hostship) do
    create(:membership, user_id: host.id, board_id: board.id, role: 'host')
  end
  let_it_be(:action_item) { build_stubbed(:action_item, board: board) }
  let_it_be(:closed_action_item) { build_stubbed(:action_item, board: board, status: 'closed') }
  let(:policy) { described_class.new(action_item, user: test_user, board: board) }

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is a host' do
      let(:test_user) { host }
      it { is_expected.to eq true }
    end

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq true }
    end

    context 'when user is not a creator' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#move?' do
    subject { policy.apply(:move?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not a creator' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#close?' do
    subject { policy.apply(:close?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not a creator' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#complete?' do
    subject { policy.apply(:complete?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not a creator' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#reopen?' do
    let(:policy) { described_class.new(closed_action_item, user: test_user, board: board) }
    subject { policy.apply(:reopen?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not a creator' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#user_is_creator?' do
    subject { policy.apply(:user_is_creator?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not a creator' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#destroy?' do
    subject { policy.apply(:destroy?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a board member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a board member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#move?' do
    subject { policy.apply(:move?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }

      it 'returns true if aasm state pending?' do
        allow(action_item).to receive(:pending?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:pending?)
      end
    end

    context 'when user is a board member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#close?' do
    subject { policy.apply(:close?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }

      it 'returns true if aasm state may transition to closed' do
        allow(action_item).to receive(:may_close?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:may_close?)
      end
    end

    context 'when user is a board member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#complete?' do
    let(:action_item) { build_stubbed(:action_item, board: board, status: 'pending') }
    subject { policy.apply(:complete?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }

      it 'returns true if aasm state may transition to completed' do
        allow(action_item).to receive(:may_complete?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:may_complete?)
      end
    end

    context 'when user is a board member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#reopen?' do
    let(:action_item) { build_stubbed(:action_item, board: board, status: 'closed') }
    subject { policy.apply(:reopen?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }

      it 'returns true if aasm state may transition to pending' do
        allow(action_item).to receive(:may_reopen?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:may_reopen?)
      end
    end

    context 'when user is a board member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end
end
