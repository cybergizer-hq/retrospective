# frozen_string_literal: true

RSpec.describe BoardPolicy do
  let_it_be(:creator) { create(:user) }
  let_it_be(:admin) { create(:user) }
  let_it_be(:host) { create(:user) }
  let_it_be(:member) { create(:user) }
  let(:not_member) { build_stubbed(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:membership) { create(:membership, user: member, board: board) }
  let_it_be(:creatorship) { create(:membership, user: creator, board: board, role: 'creator') }
  let_it_be(:adminship) { create(:membership, user: admin, board: board, role: 'admin') }
  let_it_be(:hostship) { create(:membership, user: host, board: board, role: 'host') }

  let(:policy) { described_class.new(board, user: test_user) }

  describe '#my? boards' do
    subject { policy.apply(:my?) }

    context 'when user exists' do
      let(:test_user) { not_member }
      it { is_expected.to eq true }
    end
  end

  describe '#participating? boards' do
    subject { policy.apply(:participating?) }

    context 'when user exists' do
      let(:test_user) { not_member }
      it { is_expected.to eq true }
    end
  end

  describe '#new?' do
    subject { policy.apply(:new?) }

    context 'when user exists' do
      let(:test_user) { not_member }
      it { is_expected.to eq true }
    end
  end

  describe '#edit?' do
    subject { policy.apply(:edit?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a board admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is a board host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
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

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'when user exists' do
      let(:test_user) { not_member }
      it { is_expected.to eq true }
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a board admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is a board host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
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

  describe '#destroy?' do
    subject { policy.apply(:destroy?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a board admin' do
      let(:test_user) { admin }
      it { is_expected.to eq false }
    end

    context 'when user is a board host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
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

  describe '#continue?' do
    subject { policy.apply(:continue?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a board admin' do
      let(:test_user) { admin }
      it { is_expected.to eq false }
    end

    context 'when user is a board host' do
      let(:test_user) { host }
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

  describe '#user_is_creator?' do
    subject { policy.apply(:user_is_creator?) }

    context 'when user is the board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not the board creator' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end
  end

  describe '#suggestions?' do
    subject { policy.apply(:suggestions?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is a board admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is a board host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#invite?' do
    subject { policy.apply(:invite?) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is a board admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is a board host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#user_is_admin?' do
    subject { policy.apply(:user_is_admin?) }

    context 'when user is a admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is not a admin' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#user_is_host?' do
    subject { policy.apply(:user_is_host?) }

    context 'when user is a host' do
      let(:test_user) { host }
      it { is_expected.to eq true }
    end

    context 'when user is not a host' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#user_is_member?' do
    subject { policy.apply(:user_is_member?) }

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq true }
    end

    context 'when user is not a member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end
end
