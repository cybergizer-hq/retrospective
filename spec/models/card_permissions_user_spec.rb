# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardPermissionsUser, type: :model do
  let_it_be(:card_permissions_user) { build_stubbed(:card_permissions_user) }
  let_it_be(:user) { build_stubbed(:user) }
  let_it_be(:card) { build_stubbed(:card) }
  let_it_be(:permission) { build_stubbed(:permission) }

  context 'associations' do
    it 'belongs to user' do
      expect(card_permissions_user).to respond_to(:user)
    end

    it 'belongs to permission' do
      expect(card_permissions_user).to respond_to(:permission)
    end

    it 'belongs to card' do
      expect(card_permissions_user).to respond_to(:card)
    end
  end

  context 'validations' do
    before { create(:card_permissions_user, permission: permission, user: user, card: card) }

    let(:with_uniq_card) do
      build_stubbed(:card_permissions_user, user: user, permission: permission)
    end
    let(:with_uniq_user) do
      build_stubbed(:card_permissions_user, permission: permission, card: card)
    end
    let(:with_uniq_permission) do
      build_stubbed(:card_permissions_user, user: user, card: card)
    end
    let(:not_uniq_permissions_user) do
      build_stubbed(:card_permissions_user, user: user, card: card, permission: permission)
    end

    it 'is valid when card is uniq' do
      expect(with_uniq_card).to be_valid
    end

    it 'is valid when user is uniq' do
      expect(with_uniq_user).to be_valid
    end

    it 'is valid when permission is uniq' do
      expect(with_uniq_permission).to be_valid
    end

    it 'is not valid when neither of user card or permission is uniq' do
      expect(not_uniq_permissions_user).to be_invalid
    end
  end
end
