# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyActionItemsDigestService do
  let_it_be(:users) { create_list(:user, 3) }

  # rubocop:disable Metrics/LineLength
  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyActionItemsMailer).to receive(:digest).with(user).and_call_original }
    subject.send_digest
  end
  # rubocop:enable Metrics/LineLength
end
