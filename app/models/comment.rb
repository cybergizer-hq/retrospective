# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :card
  belongs_to :author, class_name: 'User'
  validates_presence_of :content

  def author?(user)
    author == user
  end
end
