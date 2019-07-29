module Statistics
  class CompanySerializer < ActiveModel::Serializer
    attributes :company_id, :total_revenue, :total_no_of_booked_seats, :average_price_of_seats

    def company_id
      object.id
    end

    def total_revenue
      object.flights.sum { |flight| flight.booked_seats * flight.base_price }
    end

    def total_no_of_booked_seats
      object.flights.sum(&:booked_seats)
    end

    def average_price_of_seats
      total_revenue / total_no_of_booked_seats
    end
  end
end
