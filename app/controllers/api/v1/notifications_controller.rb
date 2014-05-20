class Api::V1::NotificationsController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  
  def index
    @notifications = Notification.all.to_a
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def update
    @notification = Notification.find(params[:id])

    read = params[:notification][:read] ||= nil

    if read && read === "false"
      read = false
    end

    if !@notification.read && read
      @notification.read_at = Time.now
    end

    if @notification.save
      render :show
    else
      render json: {success: false, message: "Failed to update notification.", errors: @notification.errors }, status: 500
    end

  end

  private

  def comment_params
    params.require(:notification).permit(:read_at)
  end


end