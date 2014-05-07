class Api::V1::CommentsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  
  def index
    @comments = Comment.all
  end 

  def show
    @comment = Comment.find(params[:id])
  end


  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render :show
    else
      invalid_attempt("Could not create Comment.", @comment)
    end
  end
 
  private

  def comment_params
    params.require(:comment).permit(:text, :commentable, :owner)
  end

end