# frozen_string_literal: true

module API
  module V1
    class CommentsController < API::V1::BaseController
      before_action only: %i[create update] do
        params.deep_transform_keys!(&:underscore)
      end

      before_action except: :create do
        @comment = Comment.find(params[:id])
        authorize! @comment
      end

      # app/graphql/mutations/add_comment_mutation.rb
      def create
        @comment = Comment.new(comment_params.merge(author: current_user))

        authorize! @comment

        if @comment.save
          prepare_and_make_response(@comment)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      # app/graphql/mutations/update_comment_mutation.rb
      def update
        if @comment.update(comment_params)
          prepare_and_make_response(@comment)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      # app/graphql/mutations/destroy_comment_mutation.rb
      def destroy
        if @comment.destroy
          prepare_and_make_response(@comment)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      # app/graphql/mutations/like_comment_mutation.rb
      def like
        if @comment.like!
          prepare_and_make_response(@comment)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      private

      def comment_params
        params.permit(:card_id, :content)
      end

      def prepare_and_make_response(comment)
        payload = serialize_resource(comment)

        CommentsChannel.broadcast_to(comment.card.board, payload)
        render json: payload
      end
    end
  end
end
