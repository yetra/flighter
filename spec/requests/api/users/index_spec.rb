RSpec.describe 'Users API index', type: :request do
  include TestHelpers::JsonResponse

  before do
    FactoryBot.create_list(:user, 3)
    FactoryBot.create(:user, last_name: 'TestName')
  end

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe 'GET /api/users(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        get '/api/users',
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to list user resources' do
        get '/api/users',
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end
    end

    context 'when authorized' do
      it 'allows admins to list user resources' do
        get '/api/users',
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['users'].count).to eq(5)
      end

      it 'supports filtering by email, first_name or last_name' do
        get '/api/users?query=test',
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['users'].count).to eq(1)
        expect(json_body['users'].first).to include('last_name' => 'TestName')
      end
    end
  end
end
