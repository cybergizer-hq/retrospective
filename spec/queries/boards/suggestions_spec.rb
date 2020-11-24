# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::Suggestions do
  let_it_be(:user) { create(:user) }
  let_it_be(:team) { create(:team) }

  it 'finds user by email' do
    result = described_class.new(user.email).call
    expect(result[:users]).to eq [user.email]
  end

  it 'finds user by uid' do
    result = described_class.new(user.uid).call
    expect(result[:users]).to eq [user.email]
  end

  it 'finds user by nickname' do
    result = described_class.new(user.nickname).call
    expect(result[:users]).to eq [user.email]
  end

  it 'finds team by name' do
    result = described_class.new(team.name).call
    expect(result[:teams]).to eq [team.name]
  end
end
