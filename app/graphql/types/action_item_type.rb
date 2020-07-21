# frozen_string_literal: true

module Types
  class ActionItemType < Types::BaseObject
    field :id, Int, null: false
    field :body, String, null: false
    field :times_moved, Int, null: false, camelize: false
    field :assignee, Types::UserType, null: true
    field :assignee_avatar_url, String, null: true, camelize: false
    field :status, String, null: true

    def assignee_avatar_url
      object.assignee.avatar.thumb.url if object.assignee
    end
  end
end
