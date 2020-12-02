# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
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
    record.card.board.memberships.exists?(user_id: user.id)
  end

  def user_is_author?
    record.author?(user)
  end
end
