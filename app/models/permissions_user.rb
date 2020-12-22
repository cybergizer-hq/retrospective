# frozen_string_literal: true

class PermissionsUser < ApplicationRecord
  belongs_to :user
  belongs_to :permission
  belongs_to :board

  validates_uniqueness_of :permission_id, scope: [:user_id, :board_id]
end
