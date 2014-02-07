module Api
  module V1

    class LocationsController < ApplicationController
      respond_to :json

      def index
        @locations = Location.all
      end

      def show
        @location = Location.where(location_params).first
      end

      def create
        @location = Location.new(location_params)
        @location.save
      end

      def update

      end

      def destroy
        @location = Location.where(params[:id])
      end

      private

      def location_params
        params.require(:location).permit(:name, :address_1, :address_2, :city, :province, :country, :postal_code)
      end

    end

  end
end