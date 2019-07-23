RSpec.describe 'Bookings API show', type: :request do
  include TestHelpers::JsonResponse

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  let(:booking) { FactoryBot.create(:booking) }
  let(:public_user_booking) { FactoryBot.create(:booking, user_id: public_user.id) }

  describe 'GET /api/bookings/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it "forbids non-admins to see others' resources" do
        get "/api/bookings/#{booking.id}",
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized' do
      it 'allows admins to see all resources' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('id', 'user', 'flight', 'created_at', 'updated_at')
        expect(json_body['booking']).to include('seat_price' => booking.seat_price,
                                                'no_of_seats' => booking.no_of_seats)
      end

      it 'allows non-admins to see their resources' do
        get "/api/bookings/#{public_user_booking.id}",
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('id', 'user', 'flight', 'created_at', 'updated_at')
        expect(json_body['booking']).to include('seat_price' => public_user_booking.seat_price,
                                                'no_of_seats' => public_user_booking.no_of_seats)
      end
    end
  end
end
