# frozen_string_literal: true

module API
  module V1
    class CardsController < API::V1::BaseController
      before_action only: %i[create update] do
        params.deep_transform_keys!(&:underscore)
      end

      before_action except: :create do
        @card = Card.find(params[:id])
        authorize! @card
      end

      # app/graphql/mutations/add_card_mutation.rb
      def create
        board = Board.find_by!(slug: params[:board_slug])
        @card = Card.new(card_params.merge(board: board, author: current_user))

        authorize! @card

        if @card.save
          prepare_and_make_response(@card)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      # app/graphql/mutations/update_card_mutation.rb
      def update
        if @card.update(card_params)
          prepare_and_make_response(@card)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      # app/graphql/mutations/destroy_card_mutation.rb
      def destroy
        if @card.destroy
          prepare_and_make_response(@card)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      # app/graphql/mutations/like_card_mutation.rb
      def like
        if @card.like!
          prepare_and_make_response(@card)
        else
          render_json_error(@card.errors.full_messages)
        end
      end

      private

      def card_params
        params.permit(:kind, :body)
      end

      def prepare_and_make_response(card)
        payload = serialize_resource(card)

        CardsChannel.broadcast_to(card.board, payload)
        render json: payload
      end
    end
  end
end
