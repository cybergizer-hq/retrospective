# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable, :omniauthable, omniauth_providers: %i[alfred]
  has_many :cards, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  has_and_belongs_to_many :teams

  has_many :memberships
  has_many :boards, through: :memberships

  mount_uploader :avatar, AvatarUploader

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Lint/ShadowingOuterLocalVariable
  def self.from_omniauth(auth)
    if (user = find_by_email(auth.info.email))
      return user if user.uid

      user.update(provider: auth.provider, uid: auth.uid, remote_avatar_url: auth.info.avatar_url)
      user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.remote_avatar_url = auth.info.avatar_url
      end
    end
  end
  # rubocop:enable Lint/ShadowingOuterLocalVariable
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
