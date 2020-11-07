# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  before do
    OmniAuth.config.test_mode = true

    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = auth_hash
    session['user_return_to'] = '/wherever' # sign_in_and_redirect @user

    allow_any_instance_of(AvatarUploader).to receive(:download!) # remote_avatar_url
  end

  describe '/alfred' do
    let!(:auth_hash) { build(:alfred_auth_hash) }

    context 'when provider did not send uid' do
      it 'redirects to the login page' do
        auth_hash.uid = nil

        get :alfred
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when provider did not send provider' do
      it 'redirects to the login page' do
        auth_hash.provider = nil

        get :alfred
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when provider sent valid auth data' do
      context 'when user is not in the database' do
        it 'creates new user and redirects' do
          expect { get :alfred }.to change { User.count }.by(1)
          expect(response).to redirect_to('/wherever')
        end
      end

      context 'when user is in the database' do
        it 'logs in existing user and redirects' do
          auth_hash.uid = 'some_uid'
          create(:user, provider: 'alfred', uid: 'some_uid')

          expect { get :alfred }.to_not change { User.count }
          expect(response).to redirect_to('/wherever')
        end
      end

      context 'when user has not persisted' do
        it 'redirects to root path' do
          auth_hash.info.email = nil

          expect { get :alfred }.to_not change { User.count }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
