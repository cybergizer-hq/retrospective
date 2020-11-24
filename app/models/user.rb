# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[alfred developer]

  has_many :cards, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  has_many :memberships
  has_many :boards, through: :memberships

  has_and_belongs_to_many :teams

  validates :nickname, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(provider, uid, info)
    user = find_by(provider: provider, uid: uid) || find_by(email: info[:email]) || new

    user.tap do |u|
      u.provider = provider
      u.uid = uid
      u.email = info[:email]
      u.password = Devise.friendly_token[0, 20] if u.new_record?
      u.remote_avatar_url = info[:avatar_url] if u.changed?
      u.nickname = info[:nickname] if u.new_record?

      u.save
    end
  end
end
