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

  def current_price
    return object.base_price if DateTime.now >= object.flys_at - 15.days

    last_minute_price
  end

  private

  def last_minute_price
    diff_in_days = (object.flys_at.to_datetime - DateTime.now).to_i

    ((2 - diff_in_days / 15) * object.base_price).round
  end
end
