# frozen_string_literal: true

class Board < ApplicationRecord
  has_many :action_items, dependent: :restrict_with_error
  has_many :cards, dependent: :restrict_with_error
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  validates_presence_of :title

  after_create :send_action_items

  belongs_to :previous_board, class_name: 'Board', optional: true
  before_create :set_slug

  def to_param
    slug
  end

  private

  def set_slug
    loop do
      self.slug = Nanoid.generate(size: 10)
      break unless Board.where(slug: slug).exists?
    end
  end

  def send_action_items
    DailyActionItemsJob.set(wait: 1.day).perform_later(self)
  end
end
