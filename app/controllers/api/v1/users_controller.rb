module Api
  module V1

    class UsersController < ApplicationController
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

  end
end