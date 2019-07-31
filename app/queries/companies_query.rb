class CompaniesQuery
  attr_reader :relation

  def initialize(relation: Company.all)
    @relation = relation
  end

  def with_stats
    relation.select('companies.id as company_id')
            .select('SUM(bookings.no_of_seats * bookings.seat_price) AS total_revenue')
            .select('SUM(bookings.no_of_seats) AS total_no_of_booked_seats')
            .select('SUM(bookings.no_of_seats * bookings.seat_price) / SUM(bookings.no_of_seats)
                     AS average_price_of_seats')
            .left_joins(flights: :bookings)
            .group(:id)
  end
end
