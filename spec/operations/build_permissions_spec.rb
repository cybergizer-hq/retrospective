# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::BuildPermissions do
  include Dry::Monads[:result]

  let(:board) { create(:board) }
  let(:user) { create(:user) }
  let!(:permission) { create(:permission, identifier: 'edit_board') }

  subject(:valid_call) { described_class.new(board, user).call(identifiers_scope: 'creator') }
  subject(:invalid_call) { described_class.new(board, user).call(identifiers_scope: 'invalid') }

  context 'with valid identifiers scope' do
    before do
      valid_call
    end

    it 'returns a success result' do
      expect(valid_call).to eq(Dry::Monads::Result::Success)
    end
    it 'builds permission to board' do
      expect(board.permissions_users.first.permission).to eq(permission)
    end
    it 'builds permission to user' do
      expect(board.permissions_users.first.user).to eq(user)
    end
  end

  context 'with invalid identifiers scope' do
    before do
      invalid_call
    end

    it 'returns a failure result' do
      expect(invalid_call).to be_a(Dry::Monads::Result::Failure)
    end
    it 'does not build permissions_users' do
      expect(board.permissions_users).to be_empty
    end
  end
end
