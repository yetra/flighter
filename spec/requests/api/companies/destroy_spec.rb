RSpec.describe 'Companies API destroy', type: :request do
  include TestHelpers::JsonResponse

  let!(:public_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:company) { FactoryBot.create(:company) }

  describe 'DELETE /api/companies/id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        expect do
          delete "/api/companies/#{company.id}",
                 headers: api_headers
        end.not_to change(Company, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to delete companies' do
        expect do
          delete "/api/companies/#{company.id}",
                 headers: api_headers(token: public_user.token)
        end.not_to change(Company, :count)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end
    end

    context 'when authorized' do
      it 'allows admins to delete companies' do
        expect do
          delete "/api/companies/#{company.id}",
                 headers: api_headers(token: admin_user.token)
        end.to change(Company, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
