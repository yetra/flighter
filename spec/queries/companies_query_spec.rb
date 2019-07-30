RSpec.describe CompaniesQuery do
  let!(:company_bots) { FactoryBot.create_list(:company, 2) }

  let!(:companies) { described_class.new.with_stats }

  before do
    FactoryBot.create(:flight_with_bookings, company_id: company_bots.first.id)
    FactoryBot.create(:flight_with_bookings, flys_at: DateTime.parse('2020-01-01T20:30:00.000Z'),
                                             lands_at: DateTime.parse('2020-01-01T23:30:00.000Z'),
                                             company_id: company_bots.first.id)

    FactoryBot.create(:flight_with_bookings, company_id: company_bots.second.id)
    FactoryBot.create(:flight_with_bookings, flys_at: DateTime.parse('2020-01-01T20:30:00.000Z'),
                                             lands_at: DateTime.parse('2020-01-01T23:30:00.000Z'),
                                             company_id: company_bots.second.id)
  end

  it 'lists all companies from database' do
    expect(companies.to_a.length).to eq(2)
  end

  it 'lists companies containing correct company_id' do
    expect(companies.first.company_id).to eq(company_bots.first.id)
  end

  it 'lists companies containing correct total_revenue' do
    expect(companies.first.total_revenue).to eq(120_000 + 60_000)
  end

  it 'lists companies containing correct total_no_of_booked_seats' do
    expect(companies.first.total_no_of_booked_seats).to eq(2 * 150)
  end

  it 'lists companies containing correct average_price_of_seats' do
    expect(companies.first.average_price_of_seats).to eq((800 + 400) / 2.0)
  end
end
