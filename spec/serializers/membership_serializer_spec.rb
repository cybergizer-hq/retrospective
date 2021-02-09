# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipSerializer do
  let_it_be(:membership) { create(:membership, role: 'creator') }

  subject { described_class.new(membership).to_json }

  it 'makes json with id' do
    expect(subject['id']).to be_present
  end

  it 'makes json with role' do
    expect(subject).to include '"role":"creator"'
  end

  it 'makes json with ready' do
    expect(subject).to include '"ready":false'
  end

  it 'makes json with user' do
    expect(subject['user']).to be_present
  end
end
