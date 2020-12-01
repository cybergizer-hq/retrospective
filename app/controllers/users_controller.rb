# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def edit
    authorize!
  end

  def update
    authorize!

    @user.update(user_params)
    render :edit
  end

  def avatar_destroy
    authorize!

    if @user.remove_avatar!
      @user.save
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :avatar)
  end
end
