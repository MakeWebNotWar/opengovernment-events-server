class UsersController < ApplicationController
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

  def users_params
    params.require(:users).permit(:name, :email, :password, :password_confirmation)
  end

end