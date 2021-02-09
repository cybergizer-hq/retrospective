# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let_it_be(:user) { create(:user) }

  before { stub_connection user_id: user.id }

  it_behaves_like 'Reject'

  it_behaves_like 'Subscription' do
    let(:board) { create(:board) }
  end
end
