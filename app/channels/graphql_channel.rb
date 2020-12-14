# frozen_string_literal: true

class GraphqlChannel < ApplicationCable::Channel
  def execute(data)
    result = execute_query(data)

    payload = {
      result: result.subscription? ? { data: nil } : result.to_h,
      more: result.subscription?
    }

    transmit(payload)
  end

  def unsubscribed
    channel_id = params.fetch('channelId')
    RetrospectiveSchema.subscriptions.delete_channel_subscriptions(channel_id)
  end

  private

  def execute_query(data)
    RetrospectiveSchema.execute(
      query: data['query'],
      context: context,
      variables: data['variables'],
      operation_name: data['operationName']
    )
  end

  def context
    {
      current_user_id: current_user&.id,
      current_user: current_user,
      channel: self
    }
  end
end
