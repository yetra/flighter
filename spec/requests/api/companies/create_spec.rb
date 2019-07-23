RSpec.describe 'Companies API create', type: :request do
  include TestHelpers::JsonResponse

  let!(:public_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  let(:valid_params) { FactoryBot.attributes_for(:company) }
  let(:invalid_params) { FactoryBot.attributes_for(:company, name: '') }

  describe 'POST /api/companies(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        expect do
          post '/api/companies',
               params: { company: valid_params }.to_json,
               headers: api_headers
        end.not_to change(Company, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when unauthorized' do
      it 'forbids non-admins to create a company' do
        expect do
          post '/api/companies',
               params: { company: valid_params }.to_json,
               headers: api_headers(token: public_user.token)
        end.not_to change(Company, :count)

        expect(response).to have_http_status(:forbidden)
        expect(json_body['errors']).to include('resource')
      end
    end

    context 'when authorized with valid params' do
      it 'allows admins to create a company' do
        expect do
          post '/api/companies',
               params: { company: valid_params }.to_json,
               headers: api_headers(token: admin_user.token)
        end.to change(Company, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include('name' => valid_params[:name])
      end
    end

    context 'when authorized with invalid params' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/companies',
               params: { company: invalid_params }.to_json,
               headers: api_headers(token: admin_user.token)
        end.not_to change(Company, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end
end
