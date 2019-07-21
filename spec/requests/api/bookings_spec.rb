RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse

  let!(:bookings) { FactoryBot.create_list(:booking, 3) }
  let(:valid_booking) do
    FactoryBot.build(:booking, user_id: bookings.first.user_id, flight_id: bookings.third.flight_id)
  end

  describe 'GET /api/bookings(.:format)' do
    it 'successfully returns a list of bookings' do
      get '/api/bookings', headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['bookings'].count).to eq(3)
    end
  end

  describe 'POST /api/bookings(.:format)' do
    context 'when params are valid' do
      it 'creates a booking' do
        expect do
          post '/api/bookings',
               params: { booking: valid_booking.attributes }.to_json,
               headers: api_headers
        end.to change(Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include('seat_price' => valid_booking.seat_price,
                                                'no_of_seats' => valid_booking.no_of_seats)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/bookings',
               params: { booking: { seat_price: '', no_of_seats: '' } }.to_json,
               headers: api_headers
        end.not_to change(Booking, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('seat_price', 'no_of_seats')
      end
    end
  end

  describe 'GET /api/bookings/:id(.:format)' do
    it 'returns a single booking' do
      get "/api/bookings/#{bookings.first.id}",
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['booking']).to include('id', 'user', 'flight', 'created_at', 'updated_at')
      expect(json_body['booking']).to include('seat_price' => bookings.first.seat_price,
                                              'no_of_seats' => bookings.first.no_of_seats)
    end
  end

  describe 'PUT /api/bookings/:id(.:format)' do
    context 'when params are valid' do
      it 'updates a booking' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { seat_price: 700 } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('seat_price' => 700)
        expect(Booking.first.seat_price).to eq(700)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { seat_price: '' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('seat_price')
      end
    end
  end

  describe 'DELETE /api/bookings/:id(.:format)' do
    it 'deletes a booking' do
      expect do
        delete "/api/bookings/#{bookings.first.id}",
               headers: api_headers
      end.to change(Booking, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
