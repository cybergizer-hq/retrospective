# frozen_string_literal: true

class Permission < ApplicationRecord
  CREATOR_IDENTIFIERS = %w[view_private_board edit_board update_board get_suggestions
                           destroy_board continue_board create_cards invite_members].freeze
  MEMBER_IDENTIFIERS = %w[view_private_board create_cards].freeze

  has_many :permissions_users, dependent: :destroy
  has_many :users, through: :permissions_users

  validates_presence_of :description, :identifier
  validates_uniqueness_of :identifier

  scope :creator_permissions, -> { where(identifier: CREATOR_IDENTIFIERS) }
  scope :member_permissions, -> { where(identifier: MEMBER_IDENTIFIERS) }
end
