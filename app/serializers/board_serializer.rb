# frozen_string_literal: true

class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :created_at, :updated_at

  has_many :cards
end
