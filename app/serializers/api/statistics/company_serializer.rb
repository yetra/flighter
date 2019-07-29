module Api
  module Statistics
    class CompanySerializer < ActiveModel::Serializer
      attribute :company_id

      attribute :total_revenue

      attribute :total_no_of_booked_seats

      attribute :average_price_of_seats
    end
  end
end
