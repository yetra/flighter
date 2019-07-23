RSpec.describe 'Users API destroy', type: :request do
  include TestHelpers::JsonResponse

  let!(:user) { FactoryBot.create(:user) }

  let!(:public_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe 'DELETE /api/users/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        expect do
          delete "/api/users/#{user.id}",
                 headers: api_headers
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it "forbids non-admins to delete others' resources" do
        expect do
          delete "/api/users/#{user.id}",
                 headers: api_headers(token: public_user.token)
        end.not_to change(User, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized' do
      it 'allows admins to delete any resources' do
        expect do
          delete "/api/users/#{user.id}",
                 headers: api_headers(token: admin_user.token)
        end.to change(User, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end

      it 'allows non-admins to delete their resources' do
        expect do
          delete "/api/users/#{public_user.id}",
                 headers: api_headers(token: public_user.token)
        end.to change(User, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
