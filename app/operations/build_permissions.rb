# frozen_string_literal: true

class BuildPermissions
  IDENTIFIERS_SCOPES = %w[creator member card comment].freeze

  include Dry::Monads[:result]
  attr_reader :resource, :user

  def initialize(resource, user)
    @resource = resource
    @user = user
  end

  def call(identifiers_scope:)
    unless IDENTIFIERS_SCOPES.include?(identifiers_scope.to_s)
      return Failure('Unknown permissions identifiers scope provided')
    end

    permissions_data = Permission.public_send(
      "#{identifiers_scope}_permissions"
    ).map do |permission|
      { permission_id: permission.id, user_id: user.id }
    end

    resource.permissions_rules.build(permissions_data)
    Success()
  end
end
