class FlightSerializer < ActiveModel::Serializer
  belongs_to :company
  has_many :bookings

  attribute :id

  attribute :name
  attribute :company_name

  attribute :no_of_seats
  attribute :no_of_booked_seats

  attribute :base_price
  attribute :current_price

  attribute :flys_at
  attribute :lands_at

  attribute :created_at
  attribute :updated_at

  def company_name
    object.company.name
  end

  def no_of_booked_seats
    object.booked_seats
  end
end
