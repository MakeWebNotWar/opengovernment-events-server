class Api::V1::LocationsController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  respond_to :json

  def index
    @locations = Location.all
  end

  def show
    @location = Location.where(id: params[:id]).first
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
    params.require(:location).permit(:id, :name, :address_1, :address_2, :city, :province, :country, :postal_code)
  end

end