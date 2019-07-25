RSpec.describe 'Flights API destroy', type: :request do
  include TestHelpers::JsonResponse

  let!(:public_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:flight) { FactoryBot.create(:flight) }

  describe 'DELETE /api/flights/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        expect do
          delete "/api/flights/#{flight.id}",
                 headers: api_headers
        end.not_to change(Flight, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to delete flights' do
        expect do
          delete "/api/flights/#{flight.id}",
                 headers: api_headers(token: public_user.token)
        end.not_to change(Flight, :count)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end
    end

    context 'when authorized' do
      it 'allows admins to delete flights' do
        expect do
          delete "/api/flights/#{flight.id}",
                 headers: api_headers(token: admin_user.token)
        end.to change(Flight, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
