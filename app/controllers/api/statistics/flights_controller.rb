module Api
  module Statistics
    class FlightsController < ApplicationController
      before_action :require_login
      before_action :require_permission

      def index
        render json: Flight.all,
               each_serializer: Statistics::FlightSerializer,
               status: :ok
      end
    end
  end
end
