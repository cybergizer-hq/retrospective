# frozen_string_literal: true

# rubocop:disable Lint/DuplicatedKey
RSpec.describe UserPolicy do
  let_it_be(:user) { create(:user) }
  let_it_be(:another_user) { create(:user) }

  let(:policy) { described_class.new(user, user: user, user: another_user) }

  describe '#edit?' do
    subject { policy.apply(:edit?) }

    context "when user trying to enter in another user's page" do
      it { is_expected.to eq false }
    end

    context 'when user trying to enter in his profile page' do
      let(:user) { another_user }
      it { is_expected.to eq true }
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    context "when user trying to enter in another user's page" do
      it { is_expected.to eq false }
    end

    context 'when user trying to enter in his profile page' do
      let(:user) { another_user }
      it { is_expected.to eq true }
    end
  end

  describe '#avatar_destroy?' do
    subject { policy.apply(:avatar_destroy?) }

    context "when user trying to enter in another user's page" do
      it { is_expected.to eq false }
    end

    context 'when user trying to enter in his profile page' do
      let(:user) { another_user }
      it { is_expected.to eq true }
    end
  end

  describe '#users_match?' do
    subject { policy.apply(:users_match?) }

    context 'when user and record are the same' do
      let(:user) { another_user }
      it { is_expected.to eq true }
    end

    context 'when user and record are different' do
      it { is_expected.to eq false }
    end
  end
end
# rubocop:enable Lint/DuplicatedKey
