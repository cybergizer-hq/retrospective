# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardSerializer do
  let_it_be(:card) { create(:card, body: 'my card', kind: 'mad') }

  subject { described_class.new(card).to_json }

  it 'makes json with id' do
    expect(subject['id']).to be_present
  end

  it 'makes json with kind' do
    expect(subject).to include '"kind":"mad"'
  end

  it 'makes json with body' do
    expect(subject).to include '"body":"my card"'
  end

  it 'makes json with likes' do
    expect(subject).to include '"likes":0'
  end

  it 'makes json with author' do
    expect(subject['author']).to be_present
  end

  it 'makes json with comments' do
    expect(subject['comments']).to be_present
  end
end
