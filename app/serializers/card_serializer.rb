# frozen_string_literal: true

class CardSerializer < ActiveModel::Serializer
  attributes :id, :kind, :body, :likes
  has_one :author
  has_many :comments

  def comments
    object.comments.order('created_at DESC')
  end
end
