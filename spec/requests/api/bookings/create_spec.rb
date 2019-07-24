RSpec.describe 'Bookings API create', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }
  let(:flight) { FactoryBot.create(:flight) }

  let(:valid_params) { FactoryBot.attributes_for(:booking, flight_id: flight.id) }
  let(:invalid_params) { FactoryBot.attributes_for(:booking, seat_price: '', no_of_seats: '') }

  describe 'POST /api/bookings(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        expect do
          post '/api/bookings',
               params: { booking: valid_params }.to_json,
               headers: api_headers
        end.not_to change(Booking, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when authenticated with valid params' do
      it 'creates a booking' do
        expect do
          post '/api/bookings',
               params: { booking: valid_params }.to_json,
               headers: api_headers(token: user.token)
        end.to change(Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include('seat_price' => valid_params[:seat_price],
                                                'no_of_seats' => valid_params[:no_of_seats])
      end
    end

    context 'when authenticated with invalid params' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/bookings',
               params: { booking: invalid_params }.to_json,
               headers: api_headers(token: user.token)
        end.not_to change(Booking, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('seat_price', 'no_of_seats')
      end
    end
  end
end
