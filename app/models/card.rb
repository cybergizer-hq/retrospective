# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :board

  has_many :comments, dependent: :destroy
  has_many :permissions_rules, as: :permissionable, dependent: :destroy

  validates_presence_of :kind, :body

  def author?(user)
    author == user
  end

  def like!
    increment!(:likes)
  end
end
