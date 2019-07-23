RSpec.describe 'Bookings API update', type: :request do
  include TestHelpers::JsonResponse

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:booking) { FactoryBot.create(:booking) }
  let!(:public_user_booking) { FactoryBot.create(:booking, user_id: public_user.id) }

  describe 'PUT /api/bookings/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 700 } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when unauthorized' do
      it "forbids non-admins to update others' resources" do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 700 } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end

      it 'forbids non-admins to update user_id attribute' do
        put "/api/bookings/#{public_user_booking.id}",
            params: { booking: { user_id: admin_user.id } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end
    end

    context 'when authorized with valid params' do
      it 'allows admins to update any resources' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 700 } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('seat_price' => 700)
        expect(booking.reload.seat_price).to eq(700)
      end

      it 'allows admins to update user_id attribute' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { user_id: public_user.id } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']['user']).to include('id' => public_user.id)
        expect(booking.reload.user_id).to eq(public_user.id)
      end

      it 'allows non-admins to update their resources' do
        put "/api/bookings/#{public_user_booking.id}",
            params: { booking: { seat_price: 700 } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('seat_price' => 700)
        expect(public_user_booking.reload.seat_price).to eq(700)
      end
    end

    context 'when authorized with invalid params' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{public_user_booking.id}",
            params: { booking: { seat_price: '' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('seat_price')
      end
    end
  end
end
