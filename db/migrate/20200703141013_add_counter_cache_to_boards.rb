# frozen_string_literal: true

class AddCounterCacheToBoards < ActiveRecord::Migration[6.0]
  def change
    change_table :boards do |t|
      t.integer :users_count, default: 0
    end

    reversible do |dir|
      dir.up { init_counters }
    end
  end

  def init_counters
    execute <<-SQL.squish
      UPDATE boards
      SET users_count = (SELECT count(1)
                          FROM memberships
                         WHERE memberships.board_id = boards.id)
    SQL
  end
end
