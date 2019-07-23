FactoryBot.define do
  factory :user do
    first_name { 'Any' }
    last_name { 'Person' }

    password { 'pass' }

    sequence(:email) { |n| "user-#{n}@email.com" }

    factory :user_with_bookings do
      transient do
        bookings_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:booking, evaluator.bookings_count, user: user)
      end
    end
  end
end
