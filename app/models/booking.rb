# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer
#  seat_price  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#  flight_id   :bigint
#

class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :flight

  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }

  validate :flight_not_in_the_past

  def flight_not_in_the_past
    return unless flight.flys_at.past?

    errors.add(:flight_id, 'flight can\'t be in the past')
  end
end
