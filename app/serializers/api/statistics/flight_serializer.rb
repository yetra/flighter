module Api
  module Statistics
    class FlightSerializer < ActiveModel::Serializer
      include ActionView::Helpers::NumberHelper

      attribute :flight_id

      attribute :revenue do
        object[:revenue] || 0
      end

      attribute :no_of_booked_seats do
        object[:no_of_booked_seats] || 0
      end

      attribute :occupancy do
        if object[:occupancy].nil?
          '0.0%'
        else
          number_to_percentage(object[:occupancy] * 100, precision: 2)
        end
      end
    end
  end
end
