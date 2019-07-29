module Api
  module Statistics
    class FlightSerializer < ActiveModel::Serializer
      attribute :flight_id

      attribute :revenue

      attribute :no_of_booked_seats

      attribute :occupancy
    end
  end
end
