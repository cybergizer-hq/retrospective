# frozen_string_literal: true

Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = user.id
  auth.cookies.signed["#{scope}.expires_at"] = 1.day.from_now
end

Warden::Manager.before_logout do |_user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = nil
  auth.cookies.signed["#{scope}.expires_at"] = nil
end
