# frozen_string_literal: true

class AddNamesToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :nickname, :string, unique: true

    ActiveRecord::Base.transaction do
      User.all.find_each do |user|
        user.update(nickname: user.email[/^[^@]+/],
                    first_name: user.email[/^[^.]+/],
                    last_name: user.email[/(?<=.)[a-zA-Z]+(?=@)/])
      end
    end
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :nickname
  end
end
