# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionItemPolicy do
  let_it_be(:author) { create(:user) }
  let_it_be(:not_author) { build_stubbed(:user) }
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
  let_it_be(:action_item) { build_stubbed(:action_item, board: board, author: author) }
  let_it_be(:closed_action_item) do
    build_stubbed(:action_item, board: board, status: 'closed', author: author)
  end
  let(:policy) { described_class.new(action_item, user: test_user, board: board) }

  user_titles = {
    creator: 'board creator',
    author: 'author',
    admin: 'board admin',
    host: 'board host',
    member: 'board member',
    not_member: 'not board member'
  }

  describe '#create?' do
    subject { policy.apply(:create?) }

    permitted_users = %i[creator admin host member]

    permitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq true }
      end
    end

    context 'when user is not board member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#destroy?' do
    subject { policy.apply(:destroy?) }

    permitted_users = %i[creator author]
    unpermitted_users = %i[admin host member not_member]

    permitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq true }
      end
    end

    unpermitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    permitted_users = %i[creator author]
    unpermitted_users = %i[admin host member not_member]

    permitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq true }
      end
    end

    unpermitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#move?' do
    subject { policy.apply(:move?) }

    permitted_users = %i[creator author]
    unpermitted_users = %i[admin host member not_member]

    permitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }

        it { is_expected.to eq true }

        it 'when aasm state pending?' do
          allow(action_item).to receive(:pending?).and_return(true)

          is_expected.to eq true
          expect(action_item).to have_received(:pending?)
        end
      end
    end

    unpermitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#close?' do
    subject { policy.apply(:close?) }

    permitted_users = %i[creator author]
    unpermitted_users = %i[admin host member not_member]

    permitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }

        it { is_expected.to eq true }

        it 'returns true if aasm state may transition to closed' do
          allow(action_item).to receive(:may_close?).and_return(true)

          is_expected.to eq true
          expect(action_item).to have_received(:may_close?)
        end
      end
    end

    unpermitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#complete?' do
    let(:action_item) do
      build_stubbed(:action_item, board: board, status: 'pending', author: author)
    end

    subject { policy.apply(:complete?) }

    permitted_users = %i[creator author]
    unpermitted_users = %i[admin host member not_member]

    permitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }

        it 'when aasm state may transition to completed' do
          allow(action_item).to receive(:may_complete?).and_return(true)

          is_expected.to eq true
          expect(action_item).to have_received(:may_complete?)
        end
      end
    end

    unpermitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#reopen?' do
    let(:action_item) do
      build_stubbed(:action_item, board: board, status: 'closed', author: author)
    end

    subject { policy.apply(:reopen?) }

    permitted_users = %i[creator author]
    unpermitted_users = %i[admin host member not_member]

    permitted_users.each do |user_key|
      context "when user is the #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }

        it 'returns true if aasm state may transition to pending' do
          allow(action_item).to receive(:may_reopen?).and_return(true)

          is_expected.to eq true
          expect(action_item).to have_received(:may_reopen?)
        end
      end
    end

    unpermitted_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#user_is_member?' do
    subject { policy.apply(:user_is_member?) }

    context 'when user is member' do
      let(:test_user) { member }
      it { is_expected.to eq true }
    end

    context 'when user is not member' do
      let(:test_user) { not_member }
      it { is_expected.to eq false }
    end
  end

  describe '#user_is_author?' do
    subject { policy.apply(:user_is_author?) }

    invalid_users = %i[creator admin host member not_member]

    context 'when user is the action item author' do
      let(:test_user) { author }
      it { is_expected.to eq true }
    end

    invalid_users.each do |user_key|
      context "when user is not the action item author and user is #{user_titles[user_key]}" do
        let(:test_user) { not_author }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#user_is_creator?' do
    subject { policy.apply(:user_is_creator?) }

    invalid_users = %i[author admin host member not_member]

    context 'when user is board creator' do
      let(:test_user) { creator }
      it { is_expected.to eq true }
    end

    invalid_users.each do |user_key|
      context "when user is #{user_titles[user_key]}" do
        let(:test_user) { send(user_key) }
        it { is_expected.to eq false }
      end
    end
  end
end
