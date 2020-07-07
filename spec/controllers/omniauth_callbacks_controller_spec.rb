# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  let(:auth_hash) { build(:omniauth) }
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.test_mode = true
    request.env['omniauth.auth'] = auth_hash
  end

  it 'redirects' do
    get :alfred
    expect(response).to have_http_status(:redirect)
  end
end
