# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :identifier, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
