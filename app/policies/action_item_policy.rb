# frozen_string_literal: true

class ActionItemPolicy < ApplicationPolicy
  authorize :board, allow_nil: true

  def create?
    check?(:user_is_member?)
  end

  def update?
    check?(:user_is_creator?)
  end

  def destroy?
    check?(:user_is_creator?)
  end

  def move?
    check?(:user_is_creator?) && record.pending?
  end

  def close?
    check?(:user_is_creator?) && record.may_close?
  end

  def complete?
    check?(:user_is_creator?) && record.may_complete?
  end

  def reopen?
    check?(:user_is_creator?) && record.may_reopen?
  end

  def user_is_creator?
    if board
      board.memberships.exists?(user_id: user.id, role: 'creator')
    else
      record.board.memberships.exists?(user_id: user.id, role: 'creator')
    end
  end

  def user_is_member?
    board.memberships.where(user_id: user.id).exists?
  end
end
