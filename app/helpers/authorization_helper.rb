# frozen_string_literal: true

module AuthorizationHelper
  def providers
    names = %w[alfred facebook google]

    names.select { |name| ENV["#{name.upcase}_KEY"].present? }
  end
end
