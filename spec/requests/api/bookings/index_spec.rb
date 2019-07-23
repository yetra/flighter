RSpec.describe 'Bookings API index', type: :request do
  include TestHelpers::JsonResponse

  let(:public_user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }

  before do
    FactoryBot.create_list(:booking, 3)
    FactoryBot.create(:booking, user_id: public_user.id)
  end

  describe 'GET /api/bookings(.:format)' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized' do
        get '/api/bookings',
            headers: api_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      it 'allows admins to list all booking resources' do
        get '/api/bookings',
            headers: api_headers(token: admin_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['bookings'].count).to eq(4)
      end

      it 'allows non-admins to list their booking resources' do
        get '/api/bookings',
            headers: api_headers(token: public_user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['bookings'].count).to eq(1)
      end
    end
  end
end
