RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

  let!(:companies) { FactoryBot.create_list(:company, 3) }
  let(:valid_company) { FactoryBot.build(:company, name: 'Croatia Airlines') }

  describe 'GET /api/companies(.:format)' do
    it 'successfully returns a list of companies' do
      get '/api/companies',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['companies'].count).to eq(3)
    end
  end

  describe 'POST /api/companies(.:format)' do
    context 'when params are valid' do
      it 'creates a company' do
        expect do
          post '/api/companies',
               params: { company: valid_company.attributes }.to_json,
               headers: api_headers
        end.to change(Company, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include('name' => valid_company.name)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/companies',
               params: { company: { name: '' } }.to_json,
               headers: api_headers
        end.not_to change(Company, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'GET /api/companies/:id(.:format)' do
    it 'returns a single company' do
      get "/api/companies/#{companies.first.id}",
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['company']).to include('id', 'flights', 'created_at', 'updated_at')
      expect(json_body['company']).to include('name' => companies.first.name)
    end
  end

  describe 'PUT /api/companies/:id(.:format)' do
    context 'when params are valid' do
      it 'updates a company' do
        put "/api/companies/#{companies.first.id}",
            params: { company: { name: 'Lufthansa' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(json_body['company']).to include('name' => 'Lufthansa')
        expect(Company.first.name).to eq('Lufthansa')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/companies/#{companies.first.id}",
            params: { company: { name: '' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'DELETE /api/companies/:id(.:format)' do
    it 'deletes a company' do
      expect do
        delete "/api/companies/#{companies.first.id}",
               headers: api_headers
      end.to change(Company, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
