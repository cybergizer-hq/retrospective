# frozen_string_literal: true

class BoardPolicy < ApplicationPolicy
  def my?
    true
  end

  def participating?
    true
  end

  def history?
    true
  end

  def show?
    record.private ? user.allowed?('view_private_board', record.id) : true
  end

  def new?
    true
  end

  def edit?
    user.allowed?('edit_board', record.id)
  end

  def create?
    true
  end

  def update?
    user.allowed?('update_board', record.id)
  end

  def destroy?
    user.allowed?('destroy_board', record.id)
  end

  def continue?
    user.allowed?('continue_board', record.id) && can_continue?
  end

  def create_cards?
    user.allowed?('create_cards', record.id)
  end

  def suggestions?
    user.allowed?('get_suggestions', record.id)
  end

  def invite?
    user.allowed?('invite_members', record.id)
  end

  def can_continue?
    !Board.exists?(previous_board_id: record.id)
  end
end
