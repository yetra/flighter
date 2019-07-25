FactoryBot.define do
  factory :user do
    transient do
      admin { false }
    end

    first_name { 'Any' }
    last_name { 'Person' }

    password { 'pass' }

    sequence(:email) { |n| "user-#{n}@email.com" }

    before(:create) do |user, evaluator|
      user.role = 'admin' if evaluator.admin
    end

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
