class Api::V1::RepliesController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  def index
    @replies = Comment.all
  end

  def show
    @reply = Comment.find(params[:id])
  end

  def create

  end

  def update

  end

  def destroy

  end
end