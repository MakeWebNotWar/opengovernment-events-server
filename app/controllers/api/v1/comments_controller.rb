module Api
  module V1
    class CommentsController < ApplicationController
      
      def index
        @comments = Comment.all.to_a
      end 

      def show
        @comment = Comment.where(id: params[:id]).first
      end

      
      private

      def comment_params
        params.require(:comment).permit(:id, :text, :event, :owner)
      end


    end
  end
end