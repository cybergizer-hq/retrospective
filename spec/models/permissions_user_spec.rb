# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionsUser, type: :model do
  let_it_be(:permissions_user) { build_stubbed(:permissions_user) }
  let_it_be(:user) { build_stubbed(:user) }
  let_it_be(:another_user) { build_stubbed(:user) }
  let_it_be(:board) { build_stubbed(:board) }
  let_it_be(:another_board) { build_stubbed(:board) }
  let_it_be(:permission) { build_stubbed(:permission) }
  let_it_be(:another_permission) { build_stubbed(:permission) }

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

    it 'is valid when either permission or board or user are not uniq' do
      expect(build_stubbed(:permissions_user, permission: another_permission,
                                              user: user, board: board)).to be_valid
      expect(build_stubbed(:permissions_user, permission: permission,
                                              user: another_user, board: board)).to be_valid
      expect(build_stubbed(:permissions_user, permission: permission,
                                              user: user, board: another_board)).to be_valid
    end

    it 'is not valid without a uniq permission for board and user combination' do
      expect(build_stubbed(:permissions_user, permission: permission,
                                              user: user, board: board)).to be_invalid
    end
  end
end
