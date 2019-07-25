RSpec.describe 'Sessions API destroy', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }

  describe 'DELETE /api/session(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        delete '/api/session',
               headers: api_headers

        expect(response).to have_http_status(:unauthorized)
        expect(json_body['errors']).to include('token')
      end
    end

    context 'when authenticated' do
      it 'logs out and regenerates user token' do
        delete '/api/session',
               headers: api_headers(token: user.token)

        expect(response).to have_http_status(:no_content)
        expect(user.token).not_to eq(user.reload.token)
      end
    end
  end
end
