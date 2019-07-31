module Api
  module Statistics
    class CompanySerializer < ActiveModel::Serializer
      attribute :company_id

      attribute :total_revenue do
        object[:total_revenue] || 0
      end

      attribute :total_no_of_booked_seats do
        object[:total_no_of_booked_seats] || 0
      end

      attribute :average_price_of_seats do
        object[:average_price_of_seats].to_f || 0.0
      end
    end
  end
end
