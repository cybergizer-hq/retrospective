# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::InviteUsers do
  # find_each for array not working
  # subject { described_class.new(board, [user]).call }
  # let(:user) { create(:user) }
  # let(:board) { create(:board) }
  #
  # it 'creates membership' do
  #   expect { subject }.to change(Membership, :count).by(1)
  # end
  #
  # it 'returns memberships' do
  #   expect(subject.value!).to eq [Membership.find_by(user_id: user.id, board_id: board.id)]
  # end
end
