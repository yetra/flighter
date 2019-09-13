RSpec.describe 'Flights API index', type: :request do
  include TestHelpers::JsonResponse

  before do
    FactoryBot.create_list(:flight, 3)

    FactoryBot.create(:flight, name: 'TestName')

    FactoryBot.create(:flight, flys_at: DateTime.parse('2015-12-07T19:25:00.000Z'))
    FactoryBot.create(:flight, flys_at: DateTime.parse('2020-01-01T20:30:00.000Z'),
                               lands_at: DateTime.parse('2020-01-02T20:30:00.000Z'))

    FactoryBot.create(:flight_with_bookings)
  end

  describe 'GET /api/flights(.:format)' do
    it 'successfully returns a list of active flights' do
      get '/api/flights',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(6)
    end

    it 'supports filtering by name' do
      get '/api/flights?name_cont=test',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(1)
      expect(json_body['flights'].first).to include('name' => 'TestName')
    end

    it 'supports filtering by flys_at' do
      get '/api/flights?flys_at_eq=2020-01-01T20:30:00.000Z',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(1)
      expect(json_body['flights'].first).to include('flys_at' => '2020-01-01T20:30:00.000Z')
    end

    it 'supports filtering by number of available seats' do
      get '/api/flights?no_of_available_seats_gteq=51',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(5)
    end
  end
end
