# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let_it_be(:user) { build_stubbed(:user) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      expect(build_stubbed(:user, email: nil)).to_not be_valid
    end
  end

  context 'associations' do
    it 'has many memberships' do
      expect(user).to respond_to(:memberships)
    end

    it 'has many boards' do
      expect(user).to respond_to(:boards)
    end

    it 'has many cards' do
      expect(user).to respond_to(:cards)
    end

    it 'has many teams' do
      expect(user).to respond_to(:teams)
    end

    it 'has many action items' do
      expect(user).to respond_to(:action_items)
    end
  end

  describe '.from_omniauth' do
    subject { described_class.from_omniauth(*args) }

    context 'when the user exists in the database' do
      let_it_be(:user) do
        create(:user, provider: 'provider', uid: 'uid',
                      email: 'whoever@wherever.com', nickname: 'user_nick')
      end

      context 'when method receives args with matching provider & uid & email & nickname' do
        let(:args) { ['provider', 'uid', { email: 'whoever@wherever.com', nickname: 'user_nick' }] }

        it 'returns db user' do
          expect { subject }.not_to change { described_class.count }

          expect(subject).to eq user
          expect(subject.persisted?).to eq true
          expect(subject).to have_attributes(provider: 'provider', uid: 'uid',
                                             email: 'whoever@wherever.com',
                                             nickname: 'user_nick')
        end
      end

      context 'when method receives args with matching provider & uid & different email' do
        let(:args) { ['provider', 'uid', { email: 'whoeverelse@wherever.com' }] }

        it 'return db user with updated email' do
          expect { subject }.not_to change { described_class.count }

          expect(subject).to eq user
          expect(subject.persisted?).to eq true
          expect(subject).to have_attributes(provider: 'provider', uid: 'uid',
                                             email: 'whoeverelse@wherever.com')
        end
      end

      context 'when method receives args with different provider or uid & matching email' do
        let(:args) { ['other_provider', 'other_uid', { email: 'whoever@wherever.com' }] }

        it 'return db user with updated provider & uid' do
          expect { subject }.not_to change { described_class.count }

          expect(subject).to eq user
          expect(subject.persisted?).to eq true
          expect(subject).to have_attributes(provider: 'other_provider', uid: 'other_uid',
                                             email: 'whoever@wherever.com')
        end
      end
    end

    context 'when the user does not exist in the database' do
      context 'when method receives valid args' do
        let(:args) { ['provider', 'uid', { email: 'whoever@wherever.com', nickname: 'user_nick' }] }

        it 'creates db user' do
          expect { subject }.to change { described_class.count }.by(1)

          expect(subject).to be_a described_class
          expect(subject.persisted?).to eq true
          expect(subject).to have_attributes(provider: 'provider', uid: 'uid',
                                             email: 'whoever@wherever.com',
                                             nickname: 'user_nick')
        end
      end

      context 'when method receives invalid args' do
        let(:args) { ['provider', 'uid', { email: nil }] }

        it 'returns non persised user' do
          expect { subject }.not_to change { described_class.count }

          expect(subject).to be_a described_class
          expect(subject.persisted?).to eq false
        end
      end
    end
  end
end
