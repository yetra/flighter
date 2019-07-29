module Api
  module Statistics
    class FlightsController < ApplicationController
      def index
        render json: Flight.all,
               each_serializer: Statistics::FlightSerializer,
               status: :ok
      end
    end
  end
end
