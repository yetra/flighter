RSpec.describe 'Companies API update', type: :request do
  include TestHelpers::JsonResponse

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  let!(:company) { FactoryBot.create(:company) }

  describe 'PUT /api/companies/:id(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Updated' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to update companies' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Updated' } }.to_json,
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized with valid params' do
      it 'allows admins to update a company' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Updated' } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['company']).to include('name' => 'Updated')
        expect(company.reload.name).to eq('Updated')
      end
    end

    context 'when authorized with invalid params' do
      it 'returns 400 Bad Request' do
        put "/api/companies/#{company.id}",
            params: { company: { name: '' } }.to_json,
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end
end
