# frozen_string_literal: true

module API
  class MembershipsController < ApplicationController
    before_action :authenticate_user!, :set_board, :set_membership

    def index
      users = @board.users.pluck(:email)
      render json: users
    end

    def ready_status
      render json: @membership.ready
    end

    def ready_toggle
      @membership.update(ready: !@membership.ready)
      render json: @membership.ready
    end

    private

    def membership_params
      params.require(:membership).permit(:email)
    end

    def set_board
      @board = Board.find(params[:board_id])
    end

    def set_membership
      @membership = @board.memberships.find_by(user_id: current_user.id)
    end
  end
end