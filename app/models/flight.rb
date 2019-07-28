# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  name        :string
#  no_of_seats :integer
#  base_price  :integer
#  flys_at     :datetime
#  lands_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#

class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }

  validates :flys_at, presence: true
  validates :lands_at, presence: true
  validate :flys_before_lands

  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }

  validate :overlapping_flights

  scope :active, -> { where('flys_at > ?', DateTime.now) }

  scope :name_cont, ->(string) { where('name ILIKE ?', "%#{string}%") }
  scope :flys_at_eq, ->(timestamp) { where('flys_at = ?', timestamp) }
  scope :no_of_available_seats_gteq, lambda { |seats|
    joins(:bookings).having('flights.no_of_seats - SUM(bookings.no_of_seats) >= ?', seats)
                    .group(:id)
  }

  scope :overlapping, lambda { |flight|
    where('(flys_at <= ?) AND (lands_at >= ?)', flight.flys_at, flight.lands_at)
      .where('company_id = ?', flight.company_id)
      .where('id != ?', flight.id)
  }

  def booked_seats
    bookings.sum(&:no_of_seats)
  end

  private

  def flys_before_lands
    return unless flys_at && lands_at && flys_at >= lands_at

    errors.add(:flys_at, 'must be before lands_at')
  end

  def overlapping?
    self.class.overlapping(self).any?
  end

  def overlapping_flights
    errors.add(:flight, "flights can't overlap within the same company") if overlapping?
  end
end
