RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse

  let!(:flights) { FactoryBot.create_list(:flight, 3) }
  let(:valid_flight) do
    FactoryBot.build(:flight, name: 'Valid', company_id: flights.first.company_id)
  end

  describe 'GET /api/flights(.:format)' do
    it 'successfully returns a list of flights' do
      get '/api/flights',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(3)
    end
  end

  describe 'POST /api/flights(.:format)' do
    context 'when params are valid' do
      it 'creates a flight' do
        expect do
          post '/api/flights',
               params: { flight: valid_flight.attributes }.to_json,
               headers: api_headers
        end.to change(Flight, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include('name' => 'Valid',
                                               'no_of_seats' => 50,
                                               'base_price' => 400)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/flights',
               params: { flight: { name: 'Flight Name' } }.to_json,
               headers: api_headers
        end.not_to change(Flight, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('base_price', 'no_of_seats', 'flys_at', 'lands_at')
      end
    end
  end

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

  describe 'PUT /api/flights/:id(.:format)' do
    context 'when params are valid' do
      it 'updates a flight' do
        put "/api/flights/#{flights.first.id}",
            params: { flight: { name: 'Updated' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(json_body['flight']).to include('name' => 'Updated')
        expect(Flight.first.name).to eq('Updated')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/flights/#{flights.first.id}",
            params: { flight: { name: '' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'DELETE /api/flights/:id(.:format)' do
    it 'deletes a flight' do
      expect do
        delete "/api/flights/#{flights.first.id}",
               headers: api_headers
      end.to change(Flight, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
