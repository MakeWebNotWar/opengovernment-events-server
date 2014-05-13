class Api::V1::SignupController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!
  
  respond_to :json

  def create
   user = User.new(signup_params)
    if user.save
      render :json=> user.as_json(:auth_token=>user.authentication_token, :email=>user.email), :status=>201
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end

  private

  def signup_params
    params.require(:signup).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end
end