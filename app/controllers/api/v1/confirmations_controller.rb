class Api::V1::ConfirmationsController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!  
  
  def show
    user = User.confirm_by_token(params[:confirmation_token])

    if user.errors.empty?
      render json: { success: true, message: user }, status: 200
    else
      render json: { success: false, message: "failed to find user"}, status: 400
    end

  end
end