class Flight < ActiveRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy
end
