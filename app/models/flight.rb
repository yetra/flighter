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
  scope :flys_at_eq, ->(timestamp) { where('DATE(flys_at) = ?', Date.parse(timestamp)) }
  scope :no_of_available_seats_gteq, lambda { |seats|
    where(id: Flight.left_joins(:bookings).group(:id)
                    .having('flights.no_of_seats - COALESCE(SUM(bookings.no_of_seats), 0) >= ?',
                            seats.to_i))
  }

  def overlapping
    company.flights.where('(flights.flys_at, flights.lands_at) OVERLAPS (?, ?)', flys_at, lands_at)
           .where.not(id: id)
  end

  def booked_seats
    bookings.sum(&:no_of_seats)
  end

  def current_price
    diff_in_days = (flys_at.to_datetime - DateTime.now).to_i

    return base_price if diff_in_days >= 15

    ((2 - [diff_in_days, 0].max / 15.0) * base_price).round
  end

  private

  def flys_before_lands
    return unless flys_at && lands_at && flys_at >= lands_at

    errors.add(:flys_at, 'must be before lands_at')
  end

  def overlapping_flights
    return if company.blank? || company.flights.blank? || overlapping.empty?

    errors.add(:flys_at, "can't overlap within the same company")
    errors.add(:lands_at, "can't overlap within the same company")
  end
end
