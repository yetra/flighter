RSpec.describe 'Sessions API create', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user, password: 'valid') }

  let(:valid_params) { { 'email' => user.email, 'password' => 'valid' } }
  let(:invalid_params) { { 'email' => user.email, 'password' => 'invalid' } }

  describe 'POST /api/session(.:format)' do
    context 'when params are valid' do
      it 'logs in with email and password' do
        post '/api/session',
             params: { session: valid_params }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['session']).to include('token' => user.token)
        expect(json_body['session']['user']).to include('first_name' => user.first_name,
                                                        'last_name' => user.last_name,
                                                        'email' => user.email)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/session',
             params: { user: invalid_params }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('credentials')
      end
    end
  end
end
