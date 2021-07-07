# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :card
  belongs_to :author, class_name: 'User'

  has_many :permissions_rules, as: :permissionable, dependent: :destroy

  validates_presence_of :content

  def author?(user)
    author == user
  end

  def like!
    increment!(:likes)
  end
end
