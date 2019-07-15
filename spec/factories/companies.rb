FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Company#{n}" }

    factory :company_with_flights do
      transient do
        flight_count { 5 }
      end

      after(:create) do |company, evaluator|
        create_list(:flight, evaluator.flight_count, company: company)
      end
    end
  end
end
