RSpec.describe 'Users API create', type: :request do
  include TestHelpers::JsonResponse

  let(:users) { FactoryBot.create_list(:user, 3) }
  let(:valid_user) { FactoryBot.build(:user, first_name: 'Name', email: 'a@b.com') }

  describe 'POST /api/users(.:format)' do
    context 'when params are valid' do
      it 'creates a user' do
        expect do
          post '/api/users',
               params: { user: valid_user.attributes }.to_json,
               headers: api_headers
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_body['user']).to include('first_name' => valid_user.first_name,
                                             'email' => valid_user.email)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        expect do
          post '/api/users',
               params: { user: { name: '', email: '' } }.to_json,
               headers: api_headers
        end.not_to change(User, :count)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('first_name', 'email')
      end
    end
  end
end
