# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  before_action do
    authorize! @user
  end

  def edit; end

  def update
    @user.update(user_params)
    render :edit
  end

  def avatar_destroy
    @user.save if @user.remove_avatar!
    render :edit
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :first_name, :last_name, :avatar)
  end
end
