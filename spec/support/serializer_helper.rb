# frozen_string_literal: true

module SerializerHelper
  def serialize_resource(resource)
    {
      data:
        ActiveModelSerializers::SerializableResource.new(
          resource, { adapter: :json, key_transform: :camel_lower }
        ).as_json
    }.to_json
  end
end
