# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :avatar, :nickname, :first_name, :last_name, :name

  def name
    "#{object.first_name} #{object.last_name}"
  end
end
