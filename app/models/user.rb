class User < ActiveRecord
  has_many :bookings, dependent: :destroy
end
