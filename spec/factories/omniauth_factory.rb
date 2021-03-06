# frozen_string_literal: true

FactoryBot.define do
  factory :alfred_auth_hash, class: OmniAuth::AuthHash do
    provider { 'alfred' }
    uid { Faker::Number.number.to_s }
    email { Faker::Internet.email }
    avatar_url { Faker::Avatar.image }
    nickname { email[/^[^@]+/] }

    initialize_with do
      new(
        **attributes.slice(:provider, :uid),
        info: attributes.slice(:email, :avatar_url)
      )
    end
  end

  factory :google_auth_hash, class: OmniAuth::AuthHash do
    initialize_with { new(Faker::Omniauth.google) }
  end

  factory :facebook_auth_hash, class: OmniAuth::AuthHash do
    initialize_with { new(Faker::Omniauth.facebook) }
  end
end
