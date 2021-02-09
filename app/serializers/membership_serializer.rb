# frozen_string_literal: true

class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :role, :ready

  belongs_to :user
end
