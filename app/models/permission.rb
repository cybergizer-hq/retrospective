# frozen_string_literal: true

class Permission < ApplicationRecord
  has_many :permissions_users, dependent: :destroy
  has_many :users, through: :permissions_users

  validates_presence_of :description, :identifier
  validates_uniqueness_of :identifier
end
