module Api
  module V1

    class EventsController < ApplicationController
      respond_to :json

      def index
        @events = Event.all
      end

      def show
        @event = Event.where(id: params[:id]).first
      end

      def create
        @event = Event.new(event_params)
        @event.save
      end

      def update
        @event = Event.where(event_params).first
        @event.attributes(event_params)
        if @event.save
          @event
        else
          render status: 400
        end
      end

      def destroy
        @event = Event.where(params[:id])
        if @event.destroy
          render status: 200
        else
          render status: 400
        end
      end

      private

      def event_params
        params.require(:event).permit(:id, :name, :description, :url, :start_date, :end_date)
      end

    end

  end
end