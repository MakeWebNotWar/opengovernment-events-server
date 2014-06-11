class Api::V1::CommentsController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  
  def index
    @comments = Comment.all.desc(:created_at)
  end 

  def show
    @comment = Comment.find(params[:id])
  end


  def create
    if current_user
      @comment = Comment.new(comment_params)
      @comment.user = current_user
      if @comment.save
        render :show
      else
        invalid_attempt("Could not create Comment.", @comment)
      end
    else
      invalid_attempt("You must be logged in to create a comment");
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.user === current_user

      if @comment.destroy
        render json: { success: true, message: "Comment Destroyed"}, status: 200
      else
        render json: { success: false, message: "Couldn't Destroy Comment"}, status: 500
      end
    else
      render json: { success: false, message: "This comment does not belong to you."}, status: 400
    end
  end
 
  private

  def comment_params
    params.require(:comment).permit(:text, :event, :user)
  end

end