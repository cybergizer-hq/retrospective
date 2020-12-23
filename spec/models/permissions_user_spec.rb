# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionsUser, type: :model do
  let_it_be(:permissions_user) { build_stubbed(:permissions_user) }
  let_it_be(:user) { build_stubbed(:user) }
  let_it_be(:board) { build_stubbed(:board) }
  let_it_be(:permission) { build_stubbed(:permission) }

  context 'associations' do
    it 'belongs to user' do
      expect(permissions_user).to respond_to(:user)
    end

    it 'belongs to permission' do
      expect(permissions_user).to respond_to(:permission)
    end

    it 'belongs to board' do
      expect(permissions_user).to respond_to(:board)
    end
  end

  context 'validations' do
    before { create(:permissions_user, permission: permission, user: user, board: board) }

    let(:with_uniq_board) { build_stubbed(:permissions_user, user: user, permission: permission) }
    let(:with_uniq_user) { build_stubbed(:permissions_user, permission: permission, board: board) }
    let(:with_uniq_permission) { build_stubbed(:permissions_user, user: user, board: board) }
    let(:not_uniq_permissions_user) do
      build_stubbed(:permissions_user, user: user, board: board, permission: permission)
    end

    it 'is valid when board is uniq' do
      expect(with_uniq_board).to be_valid
    end

    it 'is valid when user is uniq' do
      expect(with_uniq_user).to be_valid
    end

    it 'is valid when permission is uniq' do
      expect(with_uniq_permission).to be_valid
    end

    it 'is not valid when neither of user board or permission is uniq' do
      expect(not_uniq_permissions_user).to be_invalid
    end
  end
end
