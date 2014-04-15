class Api::V1::UsersController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  def index
    @users = User.all.to_a
  end

  def show
    @user = User.where(id: params[:id]).first
  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def users_params
    params.require(:users).permit(:name, :email, :password, :password_confirmation)
  end

end