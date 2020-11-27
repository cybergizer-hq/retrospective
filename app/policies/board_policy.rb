# frozen_string_literal: true

class BoardPolicy < ApplicationPolicy
  def my?
    true
  end

  def participating?
    true
  end

  def show?
    record.private ? user_is_member? : true
  end

  def new?
    true
  end

  def edit?
    user_is_creator?
  end

  def create?
    true
  end

  def update?
    user_is_creator?
  end

  def destroy?
    user_is_creator?
  end

  def continue?
    user_is_creator? && can_continue?
  end

  def create_cards?
    user_is_member?
  end

  def suggestions?
    check?(:user_is_member?)
  end

  def invite?
    check?(:user_is_member?)
  end

  def user_is_creator?
    record.creator?(user)
  end

  def user_is_member?
    record.member?(user)
  end

  def can_continue?
    !Board.exists?(previous_board_id: record.id)
  end
end
