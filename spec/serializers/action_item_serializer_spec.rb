# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionItemSerializer do
  let_it_be(:action_item) { create(:action_item, body: 'my action item') }

  subject { described_class.new(action_item).to_json }

  it 'makes json with id' do
    expect(subject['id']).to be_present
  end

  it 'makes json with body' do
    expect(subject).to include '"body":"my action item"'
  end

  it 'makes json with times moved' do
    expect(subject).to include '"times_moved":0'
  end

  it 'makes json with status' do
    expect(subject).to include '"status":"pending"'
  end

  it 'makes json with status' do
    expect(subject['assignee_avatar_url']).to be_present
  end

  it 'makes json with author' do
    expect(subject['author']).to be_present
  end

  it 'makes json with assignee' do
    expect(subject['assignee']).to be_present
  end
end
