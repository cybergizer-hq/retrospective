# frozen_string_literal: true

module API
  module V1
    class BoardsController < API::V1::BaseController
      # app/graphql/queries/boards.rb
      def index
        authorize!

        @boards = Board.includes(:cards).limit(10)

        render json: serialize_resource(@boards)
      end

      # app/graphql/queries/board.rb
      def show
        @board = Board.find(params[:id])

        authorize! @board

        render json: serialize_resource(@board)
      end
    end
  end
end
