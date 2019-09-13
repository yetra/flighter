RSpec.describe 'Companies API show', type: :request do
  include TestHelpers::JsonResponse

  let!(:companies) { FactoryBot.create_list(:company, 3) }

  describe 'GET /api/companies/:id(.:format)' do
    it 'returns a single company' do
      get "/api/companies/#{companies.first.id}",
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['company']).to include('id', 'flights', 'no_of_active_flights',
                                              'created_at', 'updated_at')
      expect(json_body['company']).to include('name' => companies.first.name)
    end
  end
end
