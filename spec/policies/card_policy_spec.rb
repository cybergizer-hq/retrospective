# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardPolicy do
  let_it_be(:author) { create(:user) }
  let_it_be(:not_an_author) { build_stubbed(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:card) { build_stubbed(:card, board: board, author: author) }
  let(:policy) { described_class.new(card, user: test_user) }
  let_it_be(:member) { create(:user) }
  let_it_be(:not_a_member) { build_stubbed(:user) }
  let_it_be(:membership) { create(:membership, user_id: member.id, board_id: board.id) }
  let_it_be(:creator) { create(:user) }
  let_it_be(:creatorship) { create(:membership, user: creator, board: board, role: 'creator') }

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'when user is a member' do
      let(:test_user) { member }
      it { is_expected.to eq true }
    end

    context 'when user is not a member' do
      let(:test_user) { not_a_member }
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
      let(:test_user) { not_a_member }
      it { is_expected.to eq false }
    end
  end

  describe '#destroy?' do
    subject { policy.apply(:destroy?) }

    context 'when user is the card author' do
      let(:test_user) { author }
      it { is_expected.to eq true }
    end

    context 'when user is creator of a board' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    context 'when user is not the card author' do
      let(:test_user) { not_an_author }
      it { is_expected.to eq false }
    end

    context 'when user is neither creator nor author' do
      let(:test_user) { member }
      it { is_expected.to eq false }
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    context 'when user is the card author' do
      let(:test_user) { author }
      it { is_expected.to eq true }
    end

    context 'when user is not the card author' do
      let(:test_user) { not_an_author }
      it { is_expected.to eq false }
    end
  end

  describe '#like?' do
    subject { policy.apply(:like?) }

    context 'when user is the card author' do
      let(:test_user) { author }
      it { is_expected.to eq false }
    end

    context 'when user is not the card author' do
      let(:test_user) { not_an_author }
      it { is_expected.to eq true }
    end
  end

  describe '#user_is_author?' do
    subject { policy.apply(:user_is_author?) }

    context 'when user is the card author' do
      let(:test_user) { author }
      it { is_expected.to eq true }
    end

    context 'when user is not the card author' do
      let(:test_user) { not_an_author }
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
end
