# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'test@mailer.com' if Rails.env.test? || Rails.env.development?
  layout 'mailer'
end
