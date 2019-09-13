class BookingSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :flight

  attribute :id

  attribute :seat_price
  attribute :no_of_seats

  attribute :total_price

  attribute :created_at
  attribute :updated_at

  def total_price
    object.no_of_seats * object.seat_price
  end
end
