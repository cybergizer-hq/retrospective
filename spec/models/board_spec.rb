# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  let_it_be(:board) { create(:board) }
  let_it_be(:not_a_member) { create(:user) }
  let_it_be(:member) { create(:user) }
  let_it_be(:creator) { create(:user) }
  let_it_be(:membership) { create(:membership, user_id: member.id, board_id: board.id) }
  let_it_be(:creatorship) do
    create(:membership, user_id: creator.id, board_id: board.id, role: 'creator')
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
end
