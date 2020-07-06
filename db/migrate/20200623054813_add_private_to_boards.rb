# frozen_string_literal: true

class AddPrivateToBoards < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :private, :boolean, default: false
  end
end
