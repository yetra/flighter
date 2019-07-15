FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight#{n}" }

    no_of_seats { 50 }
    base_price { 400 }

    flys_at { DateTime.now + (4.0 / 24.0) }
    lands_at { DateTime.now + (8.0 / 24.0) }

    company

    factory :flight_with_bookings do
      transient do
        bookings_count { 5 }
      end

      after(:create) do |flight, evaluator|
        create_list(:booking, evaluator.bookings_count, flight: flight)
      end
    end
  end
end
