# frozen_string_literal: true

class PermissionsRule < ApplicationRecord
  belongs_to :user
  belongs_to :permission
  belongs_to :permissionable, polymorphic: true

  validates_uniqueness_of :permission_id, scope: %i[user_id permissionable_id permissionable_type]
end
