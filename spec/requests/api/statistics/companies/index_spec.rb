RSpec.describe 'Companies Statistics API index', type: :request do
  include TestHelpers::JsonResponse

  before { FactoryBot.create_list(:company_with_flights, 3) }

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe 'GET /api/statistics/companies(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        get '/api/statistics/companies',
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to list company statistics' do
        get '/api/statistics/companies',
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end
    end

    context 'when authorized' do
      it 'allows admins to list company statistics' do
        get '/api/statistics/companies',
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['companies'].count).to eq(3)
        expect(json_body['companies'].first).to include('company_id', 'total_revenue',
                                                        'total_no_of_booked_seats',
                                                        'average_price_of_seats')
      end
    end
  end
end
