RSpec.describe 'Flights API update', type: :request do
  include TestHelpers::JsonResponse

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:flight) { FactoryBot.create(:flight) }

  describe 'PUT /api/flights/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: 'Updated' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to update flights' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: 'Updated' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized with valid params' do
      it 'allows admins to update a flight' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: 'Updated' } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['flight']).to include('name' => 'Updated')
        expect(flight.reload.name).to eq('Updated')
      end
    end

    context 'when authorized with invalid params' do
      it 'returns 400 Bad Request' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: '' } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end
end
