RSpec.describe 'Flights API create', type: :request do
  include TestHelpers::JsonResponse

  let!(:public_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:company) { FactoryBot.create(:company) }
  let(:valid_params) { FactoryBot.attributes_for(:flight, company_id: company.id) }
  let(:invalid_params) { { name: 'Flight' } }

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

    context 'when authorized with valid params' do
      it 'allows admins to create a flight' do
        expect do
          post '/api/flights',
               params: { flight: valid_params }.to_json,
               headers: api_headers(token: admin_user.token)
        end.to change(Flight, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include('name' => valid_params[:name],
                                               'no_of_seats' => valid_params[:no_of_seats],
                                               'base_price' => valid_params[:base_price])
      end
    end

    context 'when authorized with invalid params' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/flights',
               params: { flight: invalid_params }.to_json,
               headers: api_headers(token: admin_user.token)
        end.not_to change(Flight, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('base_price', 'no_of_seats', 'flys_at', 'lands_at')
      end
    end
  end
end
