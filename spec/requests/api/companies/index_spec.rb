RSpec.describe 'Companies API index', type: :request do
  include TestHelpers::JsonResponse

  let!(:companies) { FactoryBot.create_list(:company, 2) }

  before do
    FactoryBot.create(:flight, company_id: companies.first.id)
    FactoryBot.create(:flight, flys_at: DateTime.parse('2015-12-07T19:25:00.000Z'),
                               company_id: companies.second.id)
  end

  describe 'GET /api/companies(.:format)' do
    it 'successfully returns a list of companies' do
      get '/api/companies',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['companies'].count).to eq(2)
    end

    it 'lists only companies with active flights if fliter query param given' do
      get '/api/companies?filter=active',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['companies'].count).to eq(1)
    end
  end
end
