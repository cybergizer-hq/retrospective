# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  let_it_be(:user) { create(:user, email: 'user@example.com', nickname: 'user_nick') }

  subject { described_class.new(user).to_json }

  it 'makes json with email' do
    expect(subject).to include '"email":"user@example.com"'
  end

  it 'makes json with nickname' do
    expect(subject).to include '"nickname":"user_nick"'
  end

  it 'makes json with first name' do
    expect(subject).to include '"first_name":"Name"'
  end

  it 'makes json with last name' do
    expect(subject).to include '"last_name":"Surname"'
  end
end
