RSpec.describe 'Users API update', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe 'PUT /api/users/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: 'Updated' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it "forbids non-admins to update others' resources" do
        put "/api/users/#{user.id}",
            params: { user: { first_name: 'Updated' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
      end

      it 'forbids non-admins to update role attribute' do
        put "/api/users/#{public_user.id}",
            params: { user: { role: 'admin' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized with valid params' do
      it 'allows admins to update any resources' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: 'Updated' } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => 'Updated')
        expect(user.reload.first_name).to eq('Updated')
      end

      it 'allows admins to update role attribute' do
        put "/api/users/#{user.id}",
            params: { user: { role: 'admin' } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('role' => 'admin')
        expect(user.reload.admin?).to be true
      end

      it 'allows non-admins to update their resources' do
        put "/api/users/#{public_user.id}",
            params: { user: { first_name: 'Updated' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => 'Updated')
        expect(public_user.reload.first_name).to eq('Updated')
      end

      it 'allows users to change password' do
        put "/api/users/#{public_user.id}",
            params: { user: { password: 'new_pass' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(public_user.reload.authenticate('new_pass')).to eq(public_user)
      end
    end

    context 'when authorized with invalid params' do
      it 'returns 400 Bad Request' do
        put "/api/users/#{public_user.id}",
            params: { user: { first_name: '', email: '' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('first_name', 'email')
      end

      it "doesn't allow users to unset password" do
        put "/api/users/#{public_user.id}",
            params: { user: { password: '' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(public_user.reload.password).not_to be_nil
      end
    end
  end
end
