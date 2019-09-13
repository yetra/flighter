class FlightsQuery
  attr_reader :relation

  def initialize(relation: Flight.all)
    @relation = relation
  end

  def with_stats
    relation.select('flights.id as flight_id')
            .select('SUM(bookings.no_of_seats * bookings.seat_price) AS revenue')
            .select('SUM(bookings.no_of_seats) AS no_of_booked_seats')
            .select('1.0 * SUM(bookings.no_of_seats) / flights.no_of_seats AS occupancy')
            .left_joins(:bookings)
            .group(:id)
  end
end
