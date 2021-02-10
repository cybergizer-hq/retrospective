# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # rubocop:disable Metrics/AbcSize
    def alfred
      @user = User.from_omniauth(auth.provider, auth.uid, auth.info)

      if @user.valid?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Alfred') if is_navigational_format?
      else
        session['devise.alfred_data'] = auth.except('extra')
        redirect_to new_user_session_path, alert: @user.errors.full_messages.join("\n")
      end
    end

    def google
      @user = User.from_omniauth(auth.provider, auth.uid, auth.info)

      if @user.valid?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        session['devise.google_data'] = auth.except('extra')
        redirect_to new_user_session_path, alert: @user.errors.full_messages.join("\n")
      end
    end

    def facebook
      @user = User.from_omniauth(auth.provider, auth.uid, auth.info)

      if @user.valid?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        session['devise.facebook_data'] = auth.except('extra')
        redirect_to new_user_session_path, alert: @user.errors.full_messages.join("\n")
      end
    end

    def github
      @user = User.from_omniauth(auth.provider, auth.uid, auth.info)

      if @user.valid?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
      else
        session['devise.github_data'] = auth.except('extra')
        redirect_to new_user_session_path, alert: @user.errors.full_messages.join("\n")
      end
    end
    # rubocop:enable Metrics/AbcSize

    def developer
      @user = User.first

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Developer') if is_navigational_format?
    end

    def failure
      redirect_to new_user_session_path
    end

    private

    def auth
      request.env['omniauth.auth']
    end
  end
end
