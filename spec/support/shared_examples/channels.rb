# frozen_string_literal: true

shared_examples_for 'Reject' do
  it 'when board slug is not provided' do
    subscribe

    expect(subscription).to be_rejected
  end

  it 'when board slug is invalid' do
    subscribe(board_slug: -1)

    expect(subscription).to be_rejected
  end
end

shared_examples_for 'Subscription' do
  it 'when board slug is provided' do
    subscribe(board_slug: board.slug)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(Board.find_by(slug: board.slug))
  end
end
