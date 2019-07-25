RSpec.describe 'Flights API index', type: :request do
  include TestHelpers::JsonResponse

  before { FactoryBot.create_list(:flight, 3) }

  describe 'GET /api/flights(.:format)' do
    it 'successfully returns a list of flights' do
      get '/api/flights',
          headers: api_headers

      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(3)
    end
  end
end
