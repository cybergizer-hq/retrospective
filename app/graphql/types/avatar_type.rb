# frozen_string_literal: true

module Types
  class AvatarType < Types::BaseObject
    field :thumb, Types::ThumbType, null: true
  end
end
