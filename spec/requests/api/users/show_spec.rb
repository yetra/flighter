RSpec.describe 'Users API show', type: :request do
  include TestHelpers::JsonResponse
  include TestHelpers::JsonParams

  let(:user) { FactoryBot.create(:user) }

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe 'GET /api/users/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        get "/api/users/#{user.id}",
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it "forbids non-admins to see others' resources" do
        get "/api/users/#{user.id}",
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized' do
      it 'allows admins to see all resources' do
        get "/api/users/#{user.id}",
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('id', 'bookings', 'created_at', 'updated_at')
        expect(json_body['user']).to include('first_name' => user.first_name,
                                             'last_name' => user.last_name,
                                             'email' => user.email)
      end

      it 'allows non-admins to see their resources' do
        puts public_user.attributes
        get "/api/users/#{public_user.id}",
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('id', 'bookings', 'created_at', 'updated_at')
        expect(json_body['user']).to include('first_name' => public_user.first_name,
                                             'last_name' => public_user.last_name,
                                             'email' => public_user.email)
      end
    end
  end
end
