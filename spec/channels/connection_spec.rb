# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  context 'with user' do
    let_it_be(:user) { create(:user) }

    before do
      cookies.signed['user.id'] = user.id
      cookies.signed['user.expires_at'] = Time.now + 1.day
      connect '/cable'
    end

    it 'successfully connects' do
      expect(connection.current_user.id).to eq user.id
    end
  end

  context 'without user' do
    it 'rejects connection' do
      expect { connect '/cable' }.to have_rejected_connection
    end
  end
end
