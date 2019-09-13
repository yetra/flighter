FactoryBot.define do
  factory :booking do
    seat_price { 300 }
    no_of_seats { 50 }

    user
    flight
  end
end
