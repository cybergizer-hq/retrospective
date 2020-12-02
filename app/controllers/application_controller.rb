# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_raven_context
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, except: %i[sign_in sign_up]
  authorize :user, through: :current_or_guest_user
  verify_authorized unless: [:devise_controller?]

  rescue_from ActionPolicy::Unauthorized do |ex|
    redirect_to root_path, alert: ex.result.message
  end

  private

  def set_raven_context
    Raven.user_context(id: current_user.id) if current_user
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def current_or_guest_user
    current_user || User.new
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController
  # as that could cause an infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end
end
