# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit?
    true
  end

  def update?
    true
  end
end
