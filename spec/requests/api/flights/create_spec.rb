RSpec.describe 'Flights API create', type: :request do
  include TestHelpers::JsonResponse

  let!(:public_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:company) { FactoryBot.create(:company) }
  let(:valid_params) { FactoryBot.attributes_for(:flight, name: 'Valid', company_id: company.id) }

  describe 'POST /api/flights(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        expect do
          post '/api/flights',
               params: { flight: valid_params }.to_json,
               headers: api_headers
        end.not_to change(Flight, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to create a flight' do
        expect do
          post '/api/flights',
               params: { flight: valid_params }.to_json,
               headers: api_headers(token: public_user.token)
        end.not_to change(Flight, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized' do
      it 'allows admins to create a flight' do
        expect do
          post '/api/flights',
               params: { flight: valid_params }.to_json,
               headers: api_headers(token: admin_user.token)
        end.to change(Flight, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include('name' => 'Valid',
                                               'no_of_seats' => 50,
                                               'base_price' => 400)
      end
    end
  end
end
