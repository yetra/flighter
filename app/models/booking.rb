class Booking < ActiveRecord
  belongs_to :user
  belongs_to :flight
end
