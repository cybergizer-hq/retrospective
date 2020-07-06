# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :card, null: false, foreign_key: true
      t.references :author, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
