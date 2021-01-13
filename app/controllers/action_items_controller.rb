# frozen_string_literal: true

class ActionItemsController < ApplicationController
  before_action except: :index do
    @action_item = ActionItem.find(params[:id])
    @board = @action_item.board
    authorize! @action_item, context: { board: @board }
  end

  skip_verify_authorized only: :index

  def index
    @action_items = user_action_items.where(status: 'pending')
                                     .eager_load(:board)
                                     .order(times_moved: :desc, created_at: :asc)

    @action_items_resolved = user_action_items.where.not(status: 'pending')
                                              .eager_load(:board)
                                              .order(updated_at: :desc)
  end

  def close
    if @action_item.close!
      redirect_to action_items_path, notice: 'Action Item was successfully closed'
    else
      redirect_to action_items_path, alert: @action_item.errors.full_messages.join(', ')
    end
  end

  def complete
    if @action_item.complete!
      redirect_to action_items_path, notice: 'Action Item was successfully completed'
    else
      redirect_to action_items_path, alert: @action_item.errors.full_messages.join(', ')
    end
  end

  def reopen
    if @action_item.reopen!
      redirect_to action_items_path, notice: 'Action Item was successfully reopened'
    else
      redirect_to action_items_path, alert: @action_item.errors.full_messages.join(', ')
    end
  end

  private

  def user_action_items
    current_user&.action_items
  end
end
