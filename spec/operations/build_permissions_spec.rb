# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::BuildPermissions do
  subject(:build_permissions) do
    described_class.new(board, user).call(identifiers_scope: identifiers_scope)
  end

  let(:board) { create(:board) }
  let(:user) { create(:user) }
  let!(:permission) { create(:permission, identifier: 'edit_board') }

  context 'valid identifiers scope' do
    let(:identifiers_scope) { 'creator' }

    it { is_expected.to be_success }

    it 'builds permission to board' do
      build_permissions
      expect(board.permissions_users.first.permission).to eq(permission)
    end

    it 'builds permission to user' do
      build_permissions
      expect(board.permissions_users.first.user).to eq(user)
    end
  end

  context 'invalid identifiers scope' do
    let(:identifiers_scope) { 'invalid' }

    it { is_expected.to be_failure }

    it 'does not build permissions_users' do
      build_permissions
      expect(board.permissions_users).to be_empty
    end
  end
end
