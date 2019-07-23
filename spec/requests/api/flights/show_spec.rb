RSpec.describe 'Flights API show', type: :request do
  include TestHelpers::JsonResponse

  let!(:flights) { FactoryBot.create_list(:flight, 3) }

  describe 'GET /api/flights/:id(.:format)' do
    it 'returns a single flight' do
      get "/api/flights/#{flights.first.id}",
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']).to include('id', 'flys_at', 'lands_at', 'bookings',
                                             'company', 'created_at', 'updated_at')
      expect(json_body['flight']).to include('name' => flights.first.name,
                                             'base_price' => flights.first.base_price,
                                             'no_of_seats' => flights.first.no_of_seats)
    end
  end
end
