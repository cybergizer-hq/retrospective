# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  let_it_be(:board) { create(:board) }
  let_it_be(:not_a_member) { create(:user) }
  let_it_be(:member) { create(:user) }
  let_it_be(:host) { create(:user) }
  let_it_be(:admin) { create(:user) }
  let_it_be(:creator) { create(:user) }
  let_it_be(:membership) { create(:membership, user_id: member.id, board_id: board.id) }
  let_it_be(:creatorship) do
    create(:membership, user_id: creator.id, board_id: board.id, role: 'creator')
  end
  let_it_be(:adminship) do
    create(:membership, user_id: admin.id, board_id: board.id, role: 'admin')
  end
  let_it_be(:hostship) do
    create(:membership, user_id: host.id, board_id: board.id, role: 'host')
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(board).to be_valid
    end

    it 'is not valid without a title' do
      expect(build_stubbed(:board, title: nil)).to_not be_valid
    end
  end

  context 'associations' do
    it 'has many cards' do
      expect(board).to respond_to(:cards)
    end

    it 'has many action items' do
      expect(board).to respond_to(:action_items)
    end

    it 'has many memberships' do
      expect(board).to respond_to(:memberships)
    end

    it 'has many users' do
      expect(board).to respond_to(:users)
    end
  end

  describe '#member?' do
    subject { board.member?(test_user) }

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

    context 'when user is not a member' do
      let(:test_user) { not_a_member }
      it { is_expected.to eq false }
    end
  end

  describe '#creator?' do
    subject { board.creator?(test_user) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is a admin' do
      let(:test_user) { admin }
      it { is_expected.to eq false }
    end

    context 'when user is a host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
    end

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_a_member }
      it { is_expected.to eq false }
    end
  end

  describe '#admin?' do
    subject { board.admin?(test_user) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq false }
    end

    context 'when user is a admin' do
      let(:test_user) { admin }
      it { is_expected.to eq true }
    end

    context 'when user is a host' do
      let(:test_user) { host }
      it { is_expected.to eq false }
    end

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_a_member }
      it { is_expected.to eq false }
    end
  end

  describe '#host?' do
    subject { board.host?(test_user) }

    context 'when user is a creator' do
      let(:test_user) { creator }
      it { is_expected.to eq false }
    end

    context 'when user is a admin' do
      let(:test_user) { admin }
      it { is_expected.to eq false }
    end

    context 'when user is a host' do
      let(:test_user) { host }
      it { is_expected.to eq true }
    end

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end

    context 'when user is not a member' do
      let(:test_user) { not_a_member }
      it { is_expected.to eq false }
    end
  end
end
