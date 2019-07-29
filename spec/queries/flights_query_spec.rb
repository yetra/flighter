RSpec.describe FlightsQuery do
  let!(:flight_bots) { FactoryBot.create_list(:flight_with_bookings, 3) }

  let!(:flights) { described_class.new.with_stats }

  it 'lists all flights from database' do
    expect(flights.to_a.length).to eq(3)
  end

  it 'lists flights containing correct flight_id' do
    expect(flights.first.flight_id).to eq(flight_bots.first.id)
  end

  it 'lists flights containing correct revenue' do
    expect(flights.first.revenue).to eq(45_000)
  end

  it 'lists flights containing correct no_of_booked_seats' do
    expect(flights.first.no_of_booked_seats).to eq(150)
  end

  it 'lists flights containing correct occupancy' do
    expect(flights.first.occupancy).to eq(0.75)
  end
end
