# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentSerializer do
  let_it_be(:comment) { create(:comment, content: 'my comment') }

  subject { described_class.new(comment).to_json }

  it 'makes json with id' do
    expect(subject['id']).to be_present
  end

  it 'makes json with content' do
    expect(subject).to include '"content":"my comment"'
  end

  it 'makes json with card_id' do
    expect(subject['card_id']).to be_present
  end

  it 'makes json with likes' do
    expect(subject).to include '"likes":0'
  end

  it 'makes json with author' do
    expect(subject['author']).to be_present
  end
end
