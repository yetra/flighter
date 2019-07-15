class FlightSerializer < ActiveModel::Serializer
  type 'booking'

  belongs_to :user
  belongs_to :flight

  attribute :id

  attribute :seat_price
  attribute :no_of_seats

  attribute :created_at
  attribute :updated_at
end
