module Api
  module V1
    
    class DocumentsController < ApplicationController
      
      def index
        @documents = location.all
      end

      def show
        @document = location.where(id: params[:id])
      end

      def create

      end

    end

    private
    def document_params
      params.require(:location).permit(:id, :name, :body)
    end

  end
end