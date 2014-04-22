class Api::V1::LocationsController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  respond_to :json

  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      render :show
    else
      invalid_attempt("Unable to create Location.", @location)
    end
  end

  def update
    @location = Location.find(params[:id])
  end

  def destroy
    @location = Location.find(params[:id])

    if @location.destroy

    else

    end
  end

  private

  def location_params
    params.require(:location).permit(:id, :name, :address_1, :address_2, :city, :province, :country, :postal_code)
  end

end