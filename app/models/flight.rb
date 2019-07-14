class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy
end
