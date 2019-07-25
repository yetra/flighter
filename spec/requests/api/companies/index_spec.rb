RSpec.describe 'Companies API index', type: :request do
  include TestHelpers::JsonResponse

  before { FactoryBot.create_list(:company, 3) }

  describe 'GET /api/companies(.:format)' do
    it 'successfully returns a list of companies' do
      get '/api/companies',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['companies'].count).to eq(3)
    end
  end
end
