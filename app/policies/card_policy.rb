# frozen_string_literal: true

class CardPolicy < ApplicationPolicy
  def create?
    check?(:user_is_member?)
  end

  def update?
    check?(:user_is_author?)
  end

  def destroy?
    check?(:user_is_author?)
  end

  def like?
    !check?(:user_is_author?)
  end

  def user_is_member?
    record.board.memberships.exists?(user_id: user.id)
  end

  def user_is_author?
    record.author?(user)
  end
end
