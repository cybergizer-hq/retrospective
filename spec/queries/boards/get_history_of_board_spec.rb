# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::GetHistoryOfBoard do
  let(:board) { create(:board) }
  let(:second_board) { create(:board, previous_board_id: board.id) }

  context 'call method' do
    it 'returns array of previous boards if they exists' do
      result = described_class.new(second_board).call
      expect(result).to eq [board]
    end

    it 'returns empty array if board does not have history' do
      result = described_class.new(board).call
      expect(result).to eq []
    end
  end
end
