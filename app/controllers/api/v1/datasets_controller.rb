module Api
  module V1

    class DatasetsController < ApplicationController

      def index
        @datasets = Dataset.all.to_a
      end

      def show
        @dataset = Dataset.find(id: params[:id])
      end

      def create

      end

      def update

      end

      def destroy

      end

      private

      def datasets_params
        params.require(:dataset).permit(:id, :name, :description, :url)
      end

    end

  end
end