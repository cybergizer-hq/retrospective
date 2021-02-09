# frozen_string_literal: true

module API
  module V1
    class BaseController < ApplicationController
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def serialize_resource(resource, adapter = :json, key_transform = :camel_lower)
        {
          data:
            ActiveModelSerializers::SerializableResource.new(
              resource, { adapter: adapter, key_transform: key_transform }
            ).as_json
        }.to_json
      end

      def render_json_error(message, status = :unprocessable_entity)
        render json: { errors: { fullMessages: message } },
               status: status
      end

      private

      def not_found
        render json: {
          errors: {
            status: '404',
            fullMessages: 'Not Found'
          }
        }, status: :not_found
      end
    end
  end
end
