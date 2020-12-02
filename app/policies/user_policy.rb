# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit?
    users_match?
  end

  def update?
    users_match?
  end

  def avatar_destroy?
    users_match?
  end

  def users_match?
    user.id == record.id
  end
end
