# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :validate_auth, only: :alfred

    def alfred
      @user = User.from_omniauth(auth.provider, auth.uid, auth.info)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Alfred') if is_navigational_format?
      else
        session['devise.alfred_data'] = auth.except('extra')
        redirect_to new_user_session_path, alert: @user.errors.full_messages.join("\n")
      end
    end

    def developer
      @user = User.first

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Developer') if is_navigational_format?
    end

    def failure
      redirect_to new_user_session_path
    end

    private

    def validate_auth
      return unless auth.provider.blank? || auth.uid.blank?

      redirect_to new_user_session_path, alert: 'Oauth provider data invalid!'
    end

    def auth
      request.env['omniauth.auth']
    end
  end
end
