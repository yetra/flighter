module Statistics
  class FlightSerializer < ActiveModel::Serializer
    attributes :flight_id, :revenue, :no_of_booked_seats, :occupancy

    def flight_id
      object.id
    end

    def revenue
      object.booked_seats * object.base_price
    end

    def no_of_booked_seats
      object.booked_seats
    end

    def occupancy
      no_of_booked_seats / object.no_of_seats.to_f
    end
  end
end
