class Api::V1::EventsController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  # before_filter :correct_user, except: [:index, :show, :create]

  respond_to :json

  def index
    params[:start_date] = Time.now if(!params[:start_date])

    @events = Event.where(:start_date.gte => params[:start_date] - 1.day).asc().to_a

    # @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    if current_user
      @event = Event.new(event_params)
      @event.owner = current_user

      if params[:location]
        location = Location.find_or_create_by(location_params)
        @event.location = location
      end

      if @event.save
        render :show
      else
        invalid_attempt("Unable to create Event.")
      end
    else
      invalid_attempt("You must be logged in.")
    end
  end

  def update
    @event = Event.find(params[:id])
    if current_user && (current_user.admin || @event.owner == current_user)
      @event.attributes(event_params)
      if @event.save
        render :show
      else
        invalid_attempt("Unable to update Event.", @event)
      end
    else
      invalid_attempt('You must be logged in and be the event creator to update this event.')
    end
  end

  def destroy
    if @event.destroy
      render json: {success: true}, status: 200
      return
    else
      render invalid_attempt("Unable to destroy Event.", @event)
    end
  end

  private

  def event_params
    params.require(:event).permit(:id, :name, :description, :url, :start_date, :end_date, :type, :user, :location)
  end

  def location_params
    params.require(:location).permit(:name, :address_1, :address_2, :city, :province, :postal_code, :country)
  end

  def correct_user
    @event = Event.find(params[:id])
    return if current_user === @event.owner
  end

end
