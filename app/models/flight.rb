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

  def flys_before_lands
    return unless flys_at && lands_at && flys_at >= lands_at

    errors.add(:flys_at, 'must be before lands_at')
  end

  def booked_seats
    bookings.sum(&:no_of_seats)
  end
end
