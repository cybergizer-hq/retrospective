# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  rescue_from ActionPolicy::Unauthorized do |ex|
    redirect_to root_path, alert: ex.result.message
  end

  def edit
    authorize! @user
  end

  def update
    authorize! @user

    @user.update(user_params)
    render :edit
  end

  def avatar_destroy
    authorize! @user

    @user.save if @user.remove_avatar!
    render :edit
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :avatar)
  end
end
