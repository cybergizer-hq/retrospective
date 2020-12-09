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

  def previous_boards
    boards_ids = Board.connection.execute(history_query).values.flatten.drop(1)
    Board.where(id: boards_ids)
  end

  private

  HISTORY_OF_BOARD = <<~SQL
    WITH RECURSIVE previous_boards(id, previous_board_id) AS (
    SELECT id, previous_board_id FROM boards WHERE id = ?
    UNION ALL
    SELECT c.id, c.previous_board_id FROM previous_boards AS p, boards AS c WHERE c.id = p.previous_board_id
    )
    SELECT id FROM previous_boards;
  SQL

  def history_query
    ActiveRecord::Base.send(:sanitize_sql_array, [HISTORY_OF_BOARD, id])
  end

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
