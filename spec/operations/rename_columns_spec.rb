# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::RenameColumns do
  subject { described_class.new(board).call(%w[mad sad glad], %w[not-mad sad glad]) }
  let(:user) { create(:user) }
  let(:board) { create(:board, column_names: %w[mad sad glad]) }
  let!(:card) { create(:card, kind: 'mad', board: board, author: user) }
  let!(:non_board_card) { create(:card, kind: 'mad', author: user) }
  it 'changes old kind cards within board' do
    expect { subject }.to change { board.cards.first.kind }.from('mad').to('not-mad')
  end

  it 'doesn\'t change cards outside the board' do
    expect { subject }.to_not change { non_board_card }
  end

  it 'returns board' do
    expect(subject.value!).to eq board
  end
end
