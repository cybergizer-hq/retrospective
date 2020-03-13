# frozen_string_literal: true

class BoardsqlController < ApplicationController
  skip_verify_authorized only: :show

  def show; end
end
