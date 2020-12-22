# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission, type: :model do
  let_it_be(:permission) { build_stubbed(:permission) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(permission).to be_valid
    end

    it 'is not valid without description' do
      expect(build_stubbed(:permission, description: nil)).to_not be_valid
    end

    it 'is not valid without identifier' do
      expect(build_stubbed(:permission, identifier: nil)).to_not be_valid
    end

    it 'is not valid without uniq identifier' do
      create(:permission, identifier: 'some_identifier')

      expect(build_stubbed(:permission, identifier: 'some_identifier')).to be_invalid
    end
  end

  context 'associations' do
    it 'has_many_users' do
      expect(permission).to respond_to(:users)
    end

    it 'has_many_permissions_users' do
      expect(permission).to respond_to(:permissions_users)
    end
  end
end
