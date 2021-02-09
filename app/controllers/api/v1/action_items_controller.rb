# frozen_string_literal: true

module API
  module V1
    class ActionItemsController < API::V1::BaseController
      before_action only: %i[create update] do
        params.deep_transform_keys!(&:underscore)
      end

      before_action except: %i[update destroy] do
        @board = Board.find_by!(slug: params[:board_slug])
      end

      before_action except: :create do
        @action_item = ActionItem.find(params[:id])
      end

      # app/graphql/mutations/add_action_item_mutation.rb
      def create
        @action_item = ActionItem.new(action_item_params.merge(board: @board, author: current_user))

        authorize! @action_item, context: { user: current_user, board: @board }

        if @action_item.save
          prepare_and_make_response(@action_item, @board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      # app/graphql/mutations/update_action_item_mutation.rb
      def update
        authorize! @action_item, context: { user: current_user, board: @action_item.board }

        if @action_item.update(action_item_params)
          prepare_and_make_response(@action_item, @action_item.board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      # app/graphql/mutations/destroy_action_item_mutation.rb
      def destroy
        authorize! @action_item, context: { user: current_user, board: @action_item.board }

        if @action_item.destroy
          prepare_and_make_response(@action_item, @action_item.board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      # app/graphql/mutations/close_action_item_mutation.rb
      def close
        authorize! @action_item, context: { user: current_user, board: @board }

        if @action_item.close!
          prepare_and_make_response(@action_item, @board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      # app/graphql/mutations/complete_action_item_mutation.rb
      def complete
        authorize! @action_item, context: { user: current_user, board: @board }

        if @action_item.complete!
          prepare_and_make_response(@action_item, @board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      # app/graphql/mutations/reopen_action_item_mutation.rb
      def reopen
        authorize! @action_item, context: { user: current_user, board: @board }

        if @action_item.reopen!
          prepare_and_make_response(@action_item, @board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      # app/graphql/mutations/move_action_item_mutation.rb
      def move
        authorize! @action_item, context: { user: current_user, board: @board }

        if @action_item.move!(@board)
          prepare_and_make_response(@action_item, @board)
        else
          render_json_error(@action_item.errors.full_messages)
        end
      end

      private

      def action_item_params
        params.permit(:body, :assignee_id)
      end

      def prepare_and_make_response(action_item, board)
        payload = serialize_resource(action_item)

        ActionItemsChannel.broadcast_to(board, payload)
        render json: payload
      end
    end
  end
end
