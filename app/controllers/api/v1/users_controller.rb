class Api::V1::UsersController < Api::V1::ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  def index
    @users = User.all.to_a
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end   

    if @user.update_attributes(user_params)
      render :show
    else
      render json: { success: false, message: "Could not update user profile.", errors: @user.errors }, status: 500
    end
  end

  def destroy

  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end

end