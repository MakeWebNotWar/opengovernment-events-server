module Api
  module V1

    class DatasetsController < ApplicationController

      def index

      end

      def show

      end

      def create

      end

      def update

      end

      def destroy

      end

      private

      def datasets_params
        params.require(:datasets).permit(:name, :description, :url)
      end

    end

  end
end