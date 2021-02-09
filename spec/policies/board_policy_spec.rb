# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardPolicy do
  let_it_be(:user) { create(:user) }
  let_it_be(:board) { create(:board) }
  let(:policy) { described_class.new(board, user: user) }

  describe '#index' do
    subject { policy.apply(:index?) }

    context 'when user exists' do
      it { is_expected.to eq true }
    end
  end

  describe '#my? boards' do
    subject { policy.apply(:my?) }

    context 'when user exists' do
      it { is_expected.to eq true }
    end
  end

  describe '#participating? boards' do
    subject { policy.apply(:participating?) }

    context 'when user exists' do
      it { is_expected.to eq true }
    end
  end

  describe '#history? boards' do
    subject { policy.apply(:history?) }

    context 'when user exists' do
      it { is_expected.to eq true }
    end
  end

  describe '#show?' do
    subject { policy.apply(:show?) }

    context 'when board is not private' do
      it { is_expected.to eq true }
    end

    context 'when board is private' do
      let_it_be(:private_board) { create(:board, private: true) }
      let_it_be(:view_private_permission) { create(:permission, identifier: 'view_private_board') }
      let(:policy) { described_class.new(private_board, user: user) }

      context 'when user has view_private_board permission' do
        let!(:permissions_user) do
          create(:permissions_user, permission: view_private_permission,
                                    user: user,
                                    board: private_board)
        end

        it { is_expected.to eq true }
      end

      context 'when user does not have view_private_board permission' do
        it { is_expected.to eq false }
      end
    end
  end

  describe '#new?' do
    subject { policy.apply(:new?) }

    context 'when user exists' do
      it { is_expected.to eq true }
    end
  end

  describe '#edit?' do
    let_it_be(:edit_permission) { create(:permission, identifier: 'edit_board') }
    subject { policy.apply(:edit?) }

    context 'when user has edit_board permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: edit_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'when user does not have edit_board permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'when user exists' do
      it { is_expected.to eq true }
    end
  end

  describe '#update?' do
    let_it_be(:update_permission) { create(:permission, identifier: 'update_board') }
    subject { policy.apply(:update?) }

    context 'when user has update_board permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: update_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'when user does not have update_board permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#destroy?' do
    let_it_be(:destroy_permission) { create(:permission, identifier: 'destroy_board') }
    subject { policy.apply(:destroy?) }

    context 'when user has destroy_board permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: destroy_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'when user does not have destroy_board permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#continue?' do
    let_it_be(:continue_permission) { create(:permission, identifier: 'continue_board') }
    subject { policy.apply(:continue?) }

    context 'when user has continue_board permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: continue_permission, user: user, board: board)
      end

      context 'and board has not been continued' do
        it { is_expected.to eq true }
      end

      context 'and board has already been continued' do
        let!(:continued_board) { create(:board, previous_board: board) }

        it { is_expected.to eq false }
      end
    end

    context 'when user does not have continue_board permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#create_cards?' do
    let_it_be(:create_cards_permission) { create(:permission, identifier: 'create_cards') }
    subject { policy.apply(:create_cards?) }

    context 'when user has create_cards permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: create_cards_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'when user does not have update_board permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#suggestions?' do
    let_it_be(:get_suggestions_permission) { create(:permission, identifier: 'get_suggestions') }
    subject { policy.apply(:suggestions?) }

    context 'when user has get_suggestions permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: get_suggestions_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'when user does not have get_suggestions permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#invite?' do
    let_it_be(:invite_member_permission) { create(:permission, identifier: 'invite_members') }
    subject { policy.apply(:invite?) }

    context 'when user has invite_members permission' do
      let!(:permissions_user) do
        create(:permissions_user, permission: invite_member_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'when user does not have invite_members permission' do
      it { is_expected.to eq false }
    end
  end
end
