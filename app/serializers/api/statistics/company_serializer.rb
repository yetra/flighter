module Api
  module Statistics
    class CompanySerializer < ActiveModel::Serializer
      include ActionView::Helpers::NumberHelper

      attribute :company_id

      attribute :total_revenue do
        object[:total_revenue] || 0
      end

      attribute :total_no_of_booked_seats do
        object[:total_no_of_booked_seats] || 0
      end

      attribute :average_price_of_seats do
        if object[:total_no_of_booked_seats].nil?
          '0.0%'
        else
          number_to_percentage(object[:total_no_of_booked_seats] * 100, precision: 2)
        end
      end
    end
  end
end
